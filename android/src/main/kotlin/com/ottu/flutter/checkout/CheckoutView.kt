package com.ottu.flutter.checkout

import android.app.AlertDialog
import android.content.Context
import android.content.res.Resources
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ScrollView
import androidx.fragment.app.FragmentActivity
import com.ottu.checkout.Checkout
import com.ottu.checkout.network.model.payment.ApiTransactionDetails
import com.ottu.checkout.network.moshi.MoshiFactory
import com.ottu.checkout.ui.base.CheckoutSdkFragment
import com.ottu.checkout.ui.theme.CheckoutTheme
import com.ottu.flutter.checkout.ext.toCheckoutButton
import com.ottu.flutter.checkout.ext.toCheckoutColor
import com.ottu.flutter.checkout.ext.toCheckoutRipple
import com.ottu.flutter.checkout.ext.toCheckoutSwitch
import com.ottu.flutter.checkout.ext.toCheckoutText
import com.ottu.flutter.checkout.ext.toCheckoutTextField
import com.squareup.moshi.JsonAdapter
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.math.abs

private const val METHOD_CHECKOUT_HEIGHT = "METHOD_CHECKOUT_HEIGHT"
private const val METHOD_PAYMENT_SUCCESS_RESULT = "METHOD_PAYMENT_SUCCESS_RESULT"
private const val METHOD_PAYMENT_ERROR_RESULT = "METHOD_PAYMENT_ERROR_RESULT"
private const val METHOD_PAYMENT_CANCEL_RESULT = "METHOD_PAYMENT_CANCEL_RESULT"
const val CHANNEL = "com.ottu.sample/checkout"
private const val TAG = "CheckoutView"

private val sessionCoroutineExceptionHandler = CoroutineExceptionHandler { _, t ->
    Log.w(TAG, "CoroutineExceptionHandler", t)
}

private val dispatcher: CoroutineDispatcher = Dispatchers.Main

private val coroutineScope = CoroutineScope(
    CoroutineName(TAG) + dispatcher + sessionCoroutineExceptionHandler,
)

private val isCheckoutInitializing = AtomicBoolean(false)

internal class CheckoutView(
    messenger: BinaryMessenger,
    id: Int,
    private val context: Context,
    private val arguments: CheckoutArguments,
) : PlatformView {
    private val methodChannel: MethodChannel

    private val checkoutView: FrameLayout = LayoutInflater.from(context)
        .inflate(R.layout.fragment_checkout_wrapper_view, null) as FrameLayout

    private var initializerErrorDialog: AlertDialog? = null

    init {
        val vParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )
        checkoutView.layoutParams = vParams
        methodChannel = MethodChannel(messenger, CHANNEL)
    }

    override fun getView(): View = checkoutView

    override fun dispose() {}

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        Log.i(TAG, "onFlutterViewDetached")
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)

        Log.i(TAG, "onFlutterViewAttached")
        if (isCheckoutInitializing.getAndSet(true).not()) {
            val fa = checkoutView.context as FragmentActivity
            val fm = fa.supportFragmentManager
            Log.i(TAG, "onFlutterViewAttached, start init")
            coroutineScope.launch {
                initCheckoutFragment(
                    resources = flutterView.resources,
                    packageName = flutterView.context.packageName
                ) { fragment ->
                    Log.d(TAG, "onFlutterViewAttached, Checkout initialized")
                    fm.beginTransaction().replace(R.id.checkout_fragment_container, fragment)
                        .commitAllowingStateLoss()
                }
            }
        }


        checkoutView.findViewById<FrameLayout>(R.id.checkout_fragment_container)
            ?.addOnLayoutChangeListener(CheckoutLayoutChangeListener { height ->
                val scroll =
                    checkoutView.findViewById<ScrollView>(R.id.checkout_fragment_container_scroll)
                val maxScroll = scroll.maxScrollAmount
                val density = checkoutView.context.resources.displayMetrics.density
                val px = ((height + 40) / density).toInt()
                Log.d(
                    TAG, "addOnLayoutChangeListener, height in px: $px, max scroll: $maxScroll"
                )
                methodChannel.invokeMethod(METHOD_CHECKOUT_HEIGHT, px)
            })
    }

    private suspend fun initCheckoutFragment(
        resources: Resources,
        packageName: String,
        onInitialized: (sdkFragment: CheckoutSdkFragment) -> Unit,
    ) {
        Log.d(TAG, "initCheckoutFragment, initialized: ${Checkout.isInitialized}")

        val builder = arguments.run {
            val paymentOptionsDisplaySettings = paymentOptionsDisplaySettings.run {
                val paymentOptionsDisplayMode =  when (mode) {
                    "list" -> Checkout.PaymentOptionsDisplaySettings.PaymentOptionsDisplayMode.List(
                        visiblePaymentItemsCount = visibleItemsCount
                    )

                    else -> Checkout.PaymentOptionsDisplaySettings.PaymentOptionsDisplayMode.BottomSheet
                }

                Checkout.PaymentOptionsDisplaySettings(
                    mode = paymentOptionsDisplayMode,
                    defaultSelectedPgCode = defaultSelectedPgCode
                )
            }

            val theme = getCheckoutTheme(arguments, resources, packageName)
            val payments = formsOfPayment?.map { key ->
                Checkout.FormsOfPayment.of(key)
            }?.filterNotNull()

            Checkout.Builder(
                merchantId = merchantId,
                sessionId = sessionId,
                apiKey = apiKey,
                amount = amount
            ).formsOfPayments(payments).theme(theme)
                .paymentOptionsDisplaySettings(settings = paymentOptionsDisplaySettings)
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

        initializerErrorDialog = AlertDialog.Builder(context).setMessage(message).setTitle(title)
            .setPositiveButton(ok) { intfc, _ ->
                intfc.dismiss()
            }.create()
        initializerErrorDialog?.show()

    }

    private fun getApiTransactionDetails(apiTransactionDetails: String): ApiTransactionDetails? {
        val moshi = MoshiFactory.newInstance()
        val jsonAdapter: JsonAdapter<ApiTransactionDetails> =
            moshi.adapter(ApiTransactionDetails::class.java)

        return try {
            jsonAdapter.fromJson(apiTransactionDetails)
        } catch (e: Exception) {
            Log.w(TAG, "getApiTransactionDetails", e)
            null
        }
    }

    private fun getCheckoutTheme(
        checkoutArguments: CheckoutArguments,
        resources: Resources,
        packageName: String,
    ): CheckoutTheme {

        return CheckoutTheme(uiMode = CheckoutTheme.UiMode.entries.find { mode -> mode.name.lowercase() == checkoutArguments.theme?.uiMode }
            ?: CheckoutTheme.UiMode.AUTO,
            showPaymentDetails = checkoutArguments.showPaymentDetails,
            appearanceLight = checkoutArguments.theme?.run {
                CheckoutTheme.Appearance(
                    mainTitleText = mainTitleText?.toCheckoutText(resources, packageName),
                    titleText = titleText?.toCheckoutText(resources, packageName),
                    selectPaymentMethodHeaderText = selectPaymentMethodHeaderText?.toCheckoutText(resources, packageName),
                    subtitleText = subtitleText?.toCheckoutText(resources, packageName),
                    feesTitleText = feesTitleText?.toCheckoutText(resources, packageName),
                    feesSubtitleText = feesSubtitleText?.toCheckoutText(resources, packageName),
                    dataLabelText = dataLabelText?.toCheckoutText(resources, packageName),
                    dataValueText = dataValueText?.toCheckoutText(resources, packageName),
                    errorMessageText = errorMessageText?.toCheckoutText(resources, packageName),
                    inputTextField = inputTextField?.toCheckoutTextField(resources, packageName),
                    sdkBackgroundColor = sdkBackgroundColor?.toCheckoutColor(),
                    selectPaymentMethodHeaderBackgroundColor = selectPaymentMethodHeaderBackgroundColor?.toCheckoutColor(),
                    modalBackgroundColor = modalBackgroundColor?.toCheckoutColor(),
                    paymentItemBackgroundColor = paymentItemBackgroundColor?.toCheckoutColor(),
                    selectorIconColor = selectorIconColor?.toCheckoutColor(),
                    savePhoneNumberIconColor = savePhoneNumberIconColor?.toCheckoutColor(),
                    button = button?.toCheckoutButton(),
                    backButton = backButton?.toCheckoutRipple(),
                    selectorButton = selectorButton?.toCheckoutButton(),
                    switch = switchControl?.toCheckoutSwitch()
                )
            },
            appearanceDark = checkoutArguments.theme?.run {
                CheckoutTheme.Appearance(
                    mainTitleText = mainTitleText?.toCheckoutText(resources, packageName),
                    titleText = titleText?.toCheckoutText(resources, packageName),
                    selectPaymentMethodHeaderText = selectPaymentMethodHeaderText?.toCheckoutText(resources, packageName),
                    subtitleText = subtitleText?.toCheckoutText(resources, packageName),
                    feesTitleText = feesTitleText?.toCheckoutText(resources, packageName),
                    feesSubtitleText = feesSubtitleText?.toCheckoutText(resources, packageName),
                    dataLabelText = dataLabelText?.toCheckoutText(resources, packageName),
                    dataValueText = dataValueText?.toCheckoutText(resources, packageName),
                    errorMessageText = errorMessageText?.toCheckoutText(resources, packageName),
                    inputTextField = inputTextField?.toCheckoutTextField(resources, packageName),
                    sdkBackgroundColor = sdkBackgroundColor?.toCheckoutColor(),
                    selectPaymentMethodHeaderBackgroundColor = selectPaymentMethodHeaderBackgroundColor?.toCheckoutColor(),
                    modalBackgroundColor = modalBackgroundColor?.toCheckoutColor(),
                    paymentItemBackgroundColor = paymentItemBackgroundColor?.toCheckoutColor(),
                    selectorIconColor = selectorIconColor?.toCheckoutColor(),
                    savePhoneNumberIconColor = savePhoneNumberIconColor?.toCheckoutColor(),
                    button = button?.toCheckoutButton(),
                    backButton = backButton?.toCheckoutRipple(),
                    selectorButton = selectorButton?.toCheckoutButton(),
                    switch = switchControl?.toCheckoutSwitch()
                )
            })
    }


    private class CheckoutLayoutChangeListener(val onHeightChanged: (Int) -> Unit) :
        View.OnLayoutChangeListener {
        override fun onLayoutChange(
            p0: View?,
            left: Int,
            top: Int,
            right: Int,
            bottom: Int,
            oldLeft: Int,
            oldTop: Int,
            oldRight: Int,
            oldBottom: Int,
        ) {
            val height = bottom - top
            val oldHeight = oldBottom - oldTop
            Log.d(
                TAG,
                "onLayoutChange, height has been changed, height: $height, oldHeight: $oldHeight"
            )
            //if (height != oldHeight) {
            onHeightChanged(abs(height))
            //}
        }
    }
}
