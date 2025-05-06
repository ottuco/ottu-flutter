package com.ottu.flutter.checkout

import android.app.AlertDialog
import android.content.Context
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
import org.json.JSONObject
import kotlin.math.abs

private const val METHOD_CHECKOUT_HEIGHT = "METHOD_CHECKOUT_HEIGHT"
const val CHANNEL = "com.ottu.sample/checkout"
private const val TAG = "CheckoutView"

private val sessionCoroutineExceptionHandler = CoroutineExceptionHandler { _, t ->
    Log.w(TAG, "CoroutineExceptionHandler", t)
}

private val dispatcher: CoroutineDispatcher = Dispatchers.Default

private val coroutineScope =
    CoroutineScope(
        CoroutineName(TAG) +
                dispatcher +
                sessionCoroutineExceptionHandler,
    )

internal class CheckoutView(
    context: Context,
    id: Int,
    val arguments: CheckoutArguments,
    messenger: BinaryMessenger,
) :
    PlatformView {
    private val methodChannel: MethodChannel

    private val checkoutView: FrameLayout =
        LayoutInflater.from(context)
            .inflate(R.layout.fragment_checkout_wrapper_view, null) as FrameLayout

    init {
        val vParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )
        checkoutView.layoutParams = vParams
        methodChannel = MethodChannel(messenger, CHANNEL)
    }

    override fun getView(): View = checkoutView

    override fun dispose() {}

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)

        Log.d(TAG, "onFlutterViewAttached")

        val fa = checkoutView.context as FragmentActivity
        val fm = fa.supportFragmentManager
        initCheckoutFragment { fragment ->
            fm.beginTransaction()
                .replace(R.id.checkout_fragment_container, fragment)
                .commitAllowingStateLoss()
        }


        checkoutView.findViewById<FrameLayout>(R.id.checkout_fragment_container)
            ?.addOnLayoutChangeListener(
                CheckoutLayoutChangeListener { height ->
                    val scroll =
                        checkoutView.findViewById<ScrollView>(R.id.checkout_fragment_container_scroll)
                    val maxScroll = scroll.maxScrollAmount
                    val density = checkoutView.context.resources.displayMetrics.density
                    val px = ((height + 40) / density).toInt()
                    Log.d(
                        TAG,
                        "addOnLayoutChangeListener, height in px: $px, max scroll: $maxScroll"
                    )
                    methodChannel.invokeMethod(METHOD_CHECKOUT_HEIGHT, px)
                })
    }

    private fun initCheckoutFragment(onInitialized: (sdkFragment: CheckoutSdkFragment) -> Unit) {
        val builder = arguments.run {
            val paymentOptionsDisplayMode =
                if (showPaymentOptionsList) Checkout.PaymentOptionsDisplayMode.List(
                    visiblePaymentItemsCount = paymentOptionsListCount
                ) else Checkout.PaymentOptionsDisplayMode.BottomSheet
            val theme = getCheckoutTheme(arguments).copy(paymentOptionsDisplayMode = paymentOptionsDisplayMode)
            val payments = formsOfPayment?.map { key ->
                Checkout.FormsOfPayment.of(key)
            }?.filterNotNull()

            Checkout
                .Builder(
                    merchantId = merchantId,
                    sessionId = sessionId,
                    apiKey = apiKey,
                    amount = amount
                )
                .formsOfPayments(payments)
                .theme(theme)
                .defaultSelectedPgCode(pgCode = defaultSelectedPgCode)
                .logger(Checkout.Logger.INFO)
                .build()
        }

        if (Checkout.isInitialized) {
            Checkout.release()
        }

        val apiTransactionDetails =
            arguments.apiTransactionDetails?.let { getApiTransactionDetails(arguments.apiTransactionDetails) }

        Log.d(TAG, "initCheckoutFragment, with apiTransactionDetails: $apiTransactionDetails")
        coroutineScope.launch {
            val sdkFragment = Checkout.init(
                context = checkoutView.context,
                builder = builder,
                setupPreload = apiTransactionDetails,
                successCallback = {
                    Log.e("TAG", "successCallback: $it")
                    showResultDialog(checkoutView.context, it)
                },
                cancelCallback = {
                    Log.e("TAG", "cancelCallback: $it")
                    showResultDialog(checkoutView.context, it)
                },
                errorCallback = { errorData, throwable ->
                    Log.e("TAG", "errorCallback: $errorData")
                    showResultDialog(checkoutView.context, errorData, throwable)
                },
            )

            onInitialized(sdkFragment)
        }
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

    private fun getCheckoutTheme(checkoutArguments: CheckoutArguments): CheckoutTheme {
        return CheckoutTheme(
            uiMode = CheckoutTheme.UiMode.entries
                .find { mode -> mode.name.lowercase() == checkoutArguments.theme?.uiMode }
                ?: CheckoutTheme.UiMode.AUTO,
            showPaymentDetails = checkoutArguments.showPaymentDetails,
            appearanceLight = checkoutArguments.theme?.run {
                CheckoutTheme.Appearance(
                    mainTitleText = mainTitleText?.toCheckoutText(),
                    titleText = titleText?.toCheckoutText(),
                    subtitleText = subtitleText?.toCheckoutText(),
                    feesTitleText = feesTitleText?.toCheckoutText(),
                    feesSubtitleText = feesSubtitleText?.toCheckoutText(),
                    dataLabelText = dataLabelText?.toCheckoutText(),
                    dataValueText = dataValueText?.toCheckoutText(),
                    errorMessageText = errorMessageText?.toCheckoutText(),
                    inputTextField = inputTextField?.toCheckoutTextField(),
                    sdkBackgroundColor = sdkBackgroundColor?.toCheckoutColor(),
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
                    mainTitleText = mainTitleText?.toCheckoutText(),
                    titleText = titleText?.toCheckoutText(),
                    subtitleText = subtitleText?.toCheckoutText(),
                    feesTitleText = feesTitleText?.toCheckoutText(),
                    feesSubtitleText = feesSubtitleText?.toCheckoutText(),
                    dataLabelText = dataLabelText?.toCheckoutText(),
                    dataValueText = dataValueText?.toCheckoutText(),
                    errorMessageText = errorMessageText?.toCheckoutText(),
                    inputTextField = inputTextField?.toCheckoutTextField(),
                    sdkBackgroundColor = sdkBackgroundColor?.toCheckoutColor(),
                    modalBackgroundColor = modalBackgroundColor?.toCheckoutColor(),
                    paymentItemBackgroundColor = paymentItemBackgroundColor?.toCheckoutColor(),
                    selectorIconColor = selectorIconColor?.toCheckoutColor(),
                    savePhoneNumberIconColor = savePhoneNumberIconColor?.toCheckoutColor(),
                    button = button?.toCheckoutButton(),
                    backButton = backButton?.toCheckoutRipple(),
                    selectorButton = selectorButton?.toCheckoutButton(),
                    switch = switchControl?.toCheckoutSwitch()
                )
            }
        )
    }

    private fun showResultDialog(
        context: Context,
        result: JSONObject?,
        throwable: Throwable? = null,
    ) {
        val sb = StringBuilder()

        result?.let {
            sb.apply {
                append(("Status : " + result.opt("status")) + "\n")
                append(("Message : " + result.opt("message")) + "\n")
                append(("Session id : " + result.opt("session_id")) + "\n")
                append(("operation : " + result.opt("operation")) + "\n")
                append(("Reference number : " + result.opt("reference_number")) + "\n")
                append(("Challenge Occurred : " + result.opt("challenge_occurred")) + "\n")
                append(("Form of payment: " + result.opt("form_of_payment")) + "\n")
            }
        } ?: run {
            sb.append(throwable?.message ?: "Unknown Error")
        }

        AlertDialog.Builder(context)
            .setTitle("Order Information")
            .setMessage(sb)
            .setPositiveButton(
                android.R.string.ok
            ) { dialog, _ ->
                dialog.dismiss()
            }
            .show()
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
