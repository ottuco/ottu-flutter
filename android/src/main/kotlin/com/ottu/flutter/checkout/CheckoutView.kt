package com.ottu.flutter.checkout

import android.app.AlertDialog
import android.content.Context
import android.content.ContextWrapper
import android.content.res.Resources
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.ottu.checkout.Checkout
import com.ottu.checkout.data.model.payment.CardVerificationResult
import com.ottu.checkout.network.model.payment.TransactionDetails
import com.ottu.checkout.network.moshi.MoshiFactory
import com.ottu.checkout.ui.theme.CheckoutTheme
import com.ottu.flutter.checkout.ext.toCheckoutButton
import com.ottu.flutter.checkout.ext.toCheckoutColor
import com.ottu.flutter.checkout.ext.toCheckoutRipple
import com.ottu.flutter.checkout.ext.toCheckoutSwitch
import com.ottu.flutter.checkout.ext.toCheckoutText
import com.ottu.flutter.checkout.ext.toCheckoutTextField
import com.ottu.flutter.checkout.ext.toPayButtonText
import com.squareup.moshi.JsonAdapter
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.math.ceil

private const val METHOD_CHECKOUT_HEIGHT = "METHOD_CHECKOUT_HEIGHT"
private const val METHOD_PAYMENT_SUCCESS_RESULT = "METHOD_PAYMENT_SUCCESS_RESULT"
private const val METHOD_PAYMENT_ERROR_RESULT = "METHOD_PAYMENT_ERROR_RESULT"
private const val METHOD_PAYMENT_CANCEL_RESULT = "METHOD_PAYMENT_CANCEL_RESULT"
private const val METHOD_ON_WIDGET_DETACHED = "METHOD_ON_WIDGET_DETACHED"
private const val METHOD_VERIFY_PAYMENT = "METHOD_VERIFY_PAYMENT"
private const val CHANNEL = "com.ottu.flutter/checkout"
private const val NESTED_WIDGET_CHANNEL = "com.ottu.flutter/checkout/nested"
private const val METHOD_NESTED_WIDGET_HEIGHT = "METHOD_NESTED_WIDGET_HEIGHT"
private const val TAG = "CheckoutView"

private val sessionCoroutineExceptionHandler = CoroutineExceptionHandler { _, t ->
    Log.w(TAG, "sessionCoroutineExceptionHandler", t)
}

private val dispatcher: CoroutineDispatcher = Dispatchers.Main

private val coroutineScope = CoroutineScope(
    CoroutineName(TAG) + dispatcher + sessionCoroutineExceptionHandler,
)

private val isCheckoutInitializing = AtomicBoolean(false)

private const val defaultCheckoutPadding = 40

internal class CheckoutView(
    messenger: BinaryMessenger,
    id: Int,
    private val context: Context,
    private val arguments: CheckoutArguments,
    private var nestedEngine: FlutterEngine? = null,
) : PlatformView {
    private val methodChannel: MethodChannel
    private val checkoutView: FrameLayout = LayoutInflater.from(context)
        .inflate(R.layout.fragment_checkout_wrapper_view, null) as FrameLayout

    private val checkoutContentLayout =
        checkoutView.findViewById<FrameLayout>(R.id.checkout_fragment_container)
    private var lastCheckoutHeight: Int? = null
    private val checkoutLayoutChangeListener = View.OnLayoutChangeListener {
            view, _, top, _, bottom, _, _, _, _ ->
        val contentHeightPx = bottom - top
        if (view.width > 0 && contentHeightPx > 0) {
            val density = view.resources.displayMetrics.density.toDouble()
            val logicalHeight = ceil((contentHeightPx + defaultCheckoutPadding) / density).toInt()
            if (lastCheckoutHeight != logicalHeight) {
                lastCheckoutHeight = logicalHeight
                Log.d(TAG, "Checkout content: ${contentHeightPx}px, Flutter height: $logicalHeight")
                methodChannel.invokeMethod(METHOD_CHECKOUT_HEIGHT, logicalHeight)
            }
        }
    }

    private var initializerErrorDialog: AlertDialog? = null

    private val nestedContainerLayout = NestedContainerLayout(context)
    private var nestedFlutterView: FlutterView? = null
    private var nestedMethodChannel: MethodChannel? = null
    private var nestedLifecycle: Lifecycle? = null
    private val nestedLifecycleObserver = object : DefaultLifecycleObserver {
        override fun onResume(owner: LifecycleOwner) {
            nestedEngine?.lifecycleChannel?.appIsResumed()
        }

        override fun onPause(owner: LifecycleOwner) {
            nestedEngine?.lifecycleChannel?.appIsInactive()
        }

        override fun onStop(owner: LifecycleOwner) {
            nestedEngine?.lifecycleChannel?.appIsPaused()
        }

        override fun onDestroy(owner: LifecycleOwner) {
            nestedEngine?.lifecycleChannel?.appIsDetached()
        }
    }


    init {
        val vParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )
        checkoutView.layoutParams = vParams
        methodChannel = MethodChannel(messenger, CHANNEL)
        checkoutContentLayout.addOnLayoutChangeListener(checkoutLayoutChangeListener)

        nestedEngine?.let { engine ->
            nestedMethodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, NESTED_WIDGET_CHANNEL).apply {
                setMethodCallHandler { call, result ->
                    if (call.method != METHOD_NESTED_WIDGET_HEIGHT) {
                        result.notImplemented()
                        return@setMethodCallHandler
                    }
                    val height = (call.arguments as? Number)?.toDouble()
                    val pixels = height?.times(context.resources.displayMetrics.density.toDouble())
                    if (height == null || !height.isFinite() || height < 0 ||
                        pixels == null || !pixels.isFinite() || pixels > Int.MAX_VALUE) {
                        result.error("INVALID_HEIGHT", "Expected a finite, non-negative height", null)
                        return@setMethodCallHandler
                    }
                    val heightPx = ceil(pixels).toInt()
                    nestedContainerLayout.updateHeight(heightPx)
                    result.success(null)
                }
            }
            nestedFlutterView = FlutterView(context, RenderMode.texture).apply {
                attachToFlutterEngine(engine)

            }

            val layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            )
            nestedContainerLayout.addView(nestedFlutterView, layoutParams)
            // Attaching a FlutterView does not resume its engine. Without these
            // events the first frame paints, but setState cannot schedule more.
            nestedLifecycle = generateSequence(context) {
                (it as? ContextWrapper)?.baseContext
            }.filterIsInstance<LifecycleOwner>().firstOrNull()?.lifecycle
            nestedLifecycle?.addObserver(nestedLifecycleObserver)

            nestedContainerLayout.layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                1,
            )

            nestedFlutterView?.post {
                nestedFlutterView?.requestLayout()
                nestedContainerLayout.requestLayout()
            }
        }
    }


    override fun getView(): View = checkoutView

    override fun dispose() {
        nestedLifecycle?.removeObserver(nestedLifecycleObserver)
        nestedLifecycle = null
        nestedEngine?.lifecycleChannel?.appIsDetached()
        checkoutContentLayout.removeOnLayoutChangeListener(checkoutLayoutChangeListener)
        nestedMethodChannel?.setMethodCallHandler(null)
        nestedMethodChannel = null
        nestedFlutterView?.detachFromFlutterEngine()
        nestedEngine?.destroy()
        nestedFlutterView = null
        nestedEngine = null
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        Log.i(TAG, "onFlutterViewDetached")
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)

        methodChannel.setMethodCallHandler { call, _ ->
            when (call.method) {
                METHOD_ON_WIDGET_DETACHED -> {
                    Log.d(TAG, "onFlutterViewAttached, handle onWidgetDetached")
                }
            }
        }

        Log.i(TAG, "onFlutterViewAttached, isCheckoutInitializing: ${isCheckoutInitializing.get()}")
        if (isCheckoutInitializing.getAndSet(true).not()) {
            val fa = checkoutView.context as FragmentActivity
            val fm = fa.supportFragmentManager
            Log.i(TAG, "onFlutterViewAttached, start init")

            initCheckoutFragment(
                resources = flutterView.resources,
                packageName = flutterView.context.packageName
            ) { fragment ->
                Log.d(TAG, "onFlutterViewAttached, Checkout initialized")
                fm.beginTransaction().replace(R.id.checkout_fragment_container, fragment)
                    .commitAllowingStateLoss()
            }

        } else {
            Log.d(TAG, "onFlutterViewAttached, isCheckoutInitializing: $isCheckoutInitializing")
        }


    }

    private fun initCheckoutFragment(
        resources: Resources,
        packageName: String,
        onInitialized: (sdkFragment: Fragment) -> Unit,
    ) {
        Log.d(TAG, "initCheckoutFragment, initialized: ${Checkout.isInitialized}")


        val displaySettings = arguments.paymentOptionsDisplaySettings.run {
            val paymentOptionsDisplayMode = when (mode) {
                "list" -> Checkout.PaymentOptionsDisplaySettings.PaymentOptionsDisplayMode.List(
                    visibleItemsCount = visibleItemsCount
                )

                else -> Checkout.PaymentOptionsDisplaySettings.PaymentOptionsDisplayMode.BottomSheet
            }

            Checkout.PaymentOptionsDisplaySettings(
                mode = paymentOptionsDisplayMode, defaultSelectedPgCode = defaultSelectedPgCode
            )
        }

        val builder = arguments.run {
            Log.d(TAG, "initCheckoutFragment, display mode")

            val theme = getCheckoutTheme(arguments, resources, packageName)
            val payments = formsOfPayment?.map { key ->
                Checkout.FormsOfPayment.of(key)
            }?.filterNotNull()
            Log.d(TAG, "initCheckoutFragment, create builder")
            Checkout.Builder(
                merchantId = merchantId,
                sessionId = sessionId,
                apiKey = apiKey,
                amount = amount
            ).formsOfPayments(payments)
                .theme(theme)
                .displaySettings(settings = displaySettings)
                .logger(Checkout.Logger.INFO).build()
        }

        val apiTransactionDetails =
            arguments.apiTransactionDetails?.let { getApiTransactionDetails(arguments.apiTransactionDetails) }

        if (Checkout.isInitialized) {
            Log.d(TAG, "initCheckoutFragment, release")
            Checkout.release()
        }

        Log.d(
            TAG,
            "initCheckoutFragment, with apiTransactionDetails"
        )

        Log.d(
            TAG,
            "initCheckoutFragment, has nested view: ${nestedFlutterView != null}"
        )

        coroutineScope.launch {
            try {
                val sdkFragment = Checkout.init(
                    context = checkoutView.context,
                    builder = builder,
                    setupPreload = apiTransactionDetails,
                    successCallback = {
                        Log.d(TAG, "successCallback: $it")
                        methodChannel.invokeMethod(METHOD_PAYMENT_SUCCESS_RESULT, it.toString())
                    },
                    cancelCallback = {
                        Log.i(TAG, "cancelCallback: $it")
                        methodChannel.invokeMethod(METHOD_PAYMENT_CANCEL_RESULT, it.toString())
                    },
                    errorCallback = { errorData, throwable ->
                        Log.e(TAG, "errorCallback: $errorData", throwable)
                        methodChannel.invokeMethod(
                            METHOD_PAYMENT_ERROR_RESULT,
                            errorData.toString()
                        )
                    },
                    verifyPayment = ::verifyPayment,
                    payButtonText = arguments.payButtonText?.toPayButtonText(),
                    nestedWidget = nestedContainerLayout.takeIf { nestedFlutterView != null },
                )

                onInitialized(sdkFragment)
            } catch (e: Exception) {
                Log.e(TAG, "initCheckoutFragment, error", e)
                handleInitException(e)
            } finally {
                isCheckoutInitializing.set(false)
            }
        }
    }

    private suspend fun verifyPayment(payload: String?): CardVerificationResult<Nothing> {
        val deferredResult = CompletableDeferred<CardVerificationResult<Nothing>>()
        methodChannel.invokeMethod(
            METHOD_VERIFY_PAYMENT,
            payload,
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    Log.i(TAG, "verifyPayment, success")
                    deferredResult.complete(CardVerificationResult.Success(null))
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e(TAG, "verifyPayment, error")
                    deferredResult.complete(CardVerificationResult.Failure(errorMessage ?: ""))
                }

                override fun notImplemented() {
                    deferredResult.complete(CardVerificationResult.Failure("Unable to find merchant Application"))
                }
            })

        return deferredResult.await()
    }

    private fun handleInitException(e: Exception) {
        val message = e.message
        Log.w(TAG, "handleInitException, ")
        message?.let { showAlert(it) }
    }

    private fun showAlert(message: String) {
        Log.i(TAG, "showPaimentCountZeroErrorAlert")

        if (initializerErrorDialog?.isShowing == true) {
            Log.i(TAG, "showErrorAlert, dismiss the old one")
            initializerErrorDialog?.dismiss();
        }

        val title = context.getString(R.string.failed)
        val ok = context.getString(R.string.ok)

        initializerErrorDialog =
            AlertDialog.Builder(context).setMessage(message).setTitle(title)
                .setPositiveButton(ok) { intfc, _ ->
                    intfc.dismiss()
                }.create()
        initializerErrorDialog?.show()

    }

    private fun getApiTransactionDetails(apiTransactionDetails: String): TransactionDetails? {
        Log.d(TAG, "getApiTransactionDetails")
        val moshi = MoshiFactory.newInstance()
        val jsonAdapter: JsonAdapter<TransactionDetails> =
            moshi.adapter(TransactionDetails::class.java)

        return try {
            jsonAdapter.fromJson(apiTransactionDetails)
        } catch (e: Exception) {
            print(e.toString())
            Log.w(TAG, "getApiTransactionDetails", e)
            null
        }
    }

    private fun getCheckoutTheme(
        checkoutArguments: CheckoutArguments,
        resources: Resources,
        packageName: String,
    ): CheckoutTheme {

        return CheckoutTheme(
            uiMode = CheckoutTheme.UiMode.entries.find { mode -> mode.name.lowercase() == checkoutArguments.theme?.uiMode }
                ?: CheckoutTheme.UiMode.AUTO,
            showPaymentDetails = checkoutArguments.showPaymentDetails,
            appearanceLight = checkoutArguments.theme?.run {
                CheckoutTheme.Appearance(
                    mainTitleText = mainTitleText?.toCheckoutText(resources, packageName),
                    titleText = titleText?.toCheckoutText(resources, packageName),
                    selectPaymentMethodHeaderText = selectPaymentMethodHeaderText?.toCheckoutText(
                        resources,
                        packageName
                    ),
                    subtitleText = subtitleText?.toCheckoutText(resources, packageName),
                    feesTitleText = feesTitleText?.toCheckoutText(resources, packageName),
                    feesSubtitleText = feesSubtitleText?.toCheckoutText(resources, packageName),
                    dataLabelText = dataLabelText?.toCheckoutText(resources, packageName),
                    dataValueText = dataValueText?.toCheckoutText(resources, packageName),
                    errorMessageText = errorMessageText?.toCheckoutText(resources, packageName),
                    inputTextField = inputTextField?.toCheckoutTextField(
                        resources,
                        packageName
                    ),
                    sdkBackgroundColor = sdkBackgroundColor?.toCheckoutColor(),
                    selectPaymentMethodHeaderBackgroundColor = selectPaymentMethodHeaderBackgroundColor?.toCheckoutColor(),
                    modalBackgroundColor = modalBackgroundColor?.toCheckoutColor(),
                    paymentItemBackgroundColor = paymentItemBackgroundColor?.toCheckoutColor(),
                    paymentItemBorderColor = paymentItemBorderColor?.toCheckoutColor(),
                    paymentItemBorderWidth = paymentItemBorderWidth,
                    paymentItemCornerRadius = paymentItemCornerRadius,
                    paymentItemDescriptionTextColor = paymentItemDescriptionTextColor?.toCheckoutColor(),
                    selectorIconColor = selectorIconColor?.toCheckoutColor(),
                    savePhoneNumberIconColor = savePhoneNumberIconColor?.toCheckoutColor(),
                    button = button?.toCheckoutButton(resources, packageName),
                    backButton = backButton?.toCheckoutRipple(),
                    selectorButton = selectorButton?.toCheckoutButton(resources, packageName),
                    switch = switchControl?.toCheckoutSwitch()
                )
            },
            appearanceDark = checkoutArguments.theme?.run {
                CheckoutTheme.Appearance(
                    mainTitleText = mainTitleText?.toCheckoutText(resources, packageName),
                    titleText = titleText?.toCheckoutText(resources, packageName),
                    selectPaymentMethodHeaderText = selectPaymentMethodHeaderText?.toCheckoutText(
                        resources,
                        packageName
                    ),
                    subtitleText = subtitleText?.toCheckoutText(resources, packageName),
                    feesTitleText = feesTitleText?.toCheckoutText(resources, packageName),
                    feesSubtitleText = feesSubtitleText?.toCheckoutText(resources, packageName),
                    dataLabelText = dataLabelText?.toCheckoutText(resources, packageName),
                    dataValueText = dataValueText?.toCheckoutText(resources, packageName),
                    errorMessageText = errorMessageText?.toCheckoutText(resources, packageName),
                    inputTextField = inputTextField?.toCheckoutTextField(
                        resources,
                        packageName
                    ),
                    sdkBackgroundColor = sdkBackgroundColor?.toCheckoutColor(),
                    selectPaymentMethodHeaderBackgroundColor = selectPaymentMethodHeaderBackgroundColor?.toCheckoutColor(),
                    modalBackgroundColor = modalBackgroundColor?.toCheckoutColor(),
                    paymentItemBackgroundColor = paymentItemBackgroundColor?.toCheckoutColor(),
                    paymentItemBorderColor = paymentItemBorderColor?.toCheckoutColor(),
                    paymentItemBorderWidth = paymentItemBorderWidth,
                    paymentItemCornerRadius = paymentItemCornerRadius,
                    selectorIconColor = selectorIconColor?.toCheckoutColor(),
                    savePhoneNumberIconColor = savePhoneNumberIconColor?.toCheckoutColor(),
                    button = button?.toCheckoutButton(resources, packageName),
                    backButton = backButton?.toCheckoutRipple(),
                    selectorButton = selectorButton?.toCheckoutButton(resources, packageName),
                    switch = switchControl?.toCheckoutSwitch()
                )
            })
    }


}

/** Keeps the Flutter viewport measurable even when the SDK applies WRAP_CONTENT. */
private class NestedContainerLayout(context: Context) : FrameLayout(context) {
    private var contentHeightPx = 1

    fun updateHeight(heightPx: Int) {
        if (contentHeightPx == heightPx) return
        contentHeightPx = heightPx
        layoutParams?.let { params ->
            params.height = heightPx
            layoutParams = params
        }
        requestLayout()
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(
            widthMeasureSpec,
            MeasureSpec.makeMeasureSpec(contentHeightPx, MeasureSpec.EXACTLY),
        )
    }
}
