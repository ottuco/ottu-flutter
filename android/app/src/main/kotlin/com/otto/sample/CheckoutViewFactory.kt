package com.otto.sample

import android.app.AlertDialog
import android.content.Context
import android.graphics.Color
import android.util.Log
import com.ottu.checkout.Checkout
import com.ottu.checkout.ui.theme.CheckoutTheme
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.json.JSONObject

private val merchantId = "alpha.ottu.net"
private val apiKey = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI"
private val formsOfPayment = listOf(
    Checkout.FormsOfPayment.GooglePay,
    Checkout.FormsOfPayment.OttuPG,
    Checkout.FormsOfPayment.DirectPayment,
    Checkout.FormsOfPayment.TokenPay,
)

class CheckoutViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        initSdk(
            context = context,
            sessionId = "7cf36a4c00d9fec8fbd07e6bc853a188b3e9d2f0",
            formsOfPayment = formsOfPayment
        )
        val creationParams = args as Map<String?, Any?>?
        return CheckoutView(
            context = context,
            id = viewId,
            creationParams = creationParams,
            messenger = messenger
        )
    }

    private fun initSdk(
        context: Context,
        sessionId: String,
        formsOfPayment: List<Checkout.FormsOfPayment>?,
    ) {
        val theme = getCheckoutTheme()

        val builder = Checkout
            .Builder(
                merchantId = merchantId,
                sessionId = sessionId,
                apiKey = apiKey,
                amount = 10.20
            )
            .formsOfPayments(formsOfPayment)
            .theme(theme)
            .logger(Checkout.Logger.INFO)
            .build()

        if (Checkout.isInitialized) {
            Checkout.release()
        }

        Checkout.init(
            context = context,
            builder = builder,
            //setupPreload = ApiTransactionDetails(amount = "12.12", ca),
            successCallback = {
                Log.e("TAG", "successCallback: $it")
                showResultDialog(context, it)
            },
            cancelCallback = {
                Log.e("TAG", "cancelCallback: $it")
                showResultDialog(context, it)
            },
            errorCallback = { errorData, throwable ->
                Log.e("TAG", "errorCallback: $errorData")
                showResultDialog(context, errorData, throwable)
            },
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

    private fun getCheckoutTheme(): CheckoutTheme {
        return CheckoutTheme(
            uiMode = CheckoutTheme.UiMode.AUTO,
            showPaymentDetails = true,
            appearanceLight = CheckoutTheme.Appearance(
                sdkBackgroundColor = CheckoutTheme.Color(
                    Color.WHITE
                )
            ),
            appearanceDark = null,
        )
    }
}