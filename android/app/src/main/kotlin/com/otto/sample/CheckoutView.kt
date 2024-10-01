package com.otto.sample

import android.app.AlertDialog
import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import com.ottu.checkout.Checkout
import com.ottu.checkout.ui.theme.CheckoutTheme
import com.ottu.sample.CHANNEL
import com.ottu.sample.MainActivity
import com.ottu.sample.R
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.json.JSONObject
import kotlin.math.abs

private const val METHOD_CHECKOUT_HEIGHT = "METHOD_CHECKOUT_HEIGHT"
private const val TAG = "CheckoutView"
private val merchantId = "alpha.ottu.net"
private val apiKey = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI"
private val sessionId = "946389075a6f7482b3738840320877ef6f887cc4"
private val formsOfPayment = listOf(
    Checkout.FormsOfPayment.GooglePay,
    Checkout.FormsOfPayment.OttuPG,
    Checkout.FormsOfPayment.DirectPayment,
    Checkout.FormsOfPayment.TokenPay,
)

internal class CheckoutView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    messenger: BinaryMessenger,
) :
    PlatformView {
    private val methodChannel: MethodChannel

    /* textView = TextView(context)
     textView.textSize = 72f
     textView.setBackgroundColor(Color.GREEN)
     textView.text = "Rendered on a native Android view (id: $id)"*/
    private val checkoutView: FrameLayout =
        LayoutInflater.from(context)
            .inflate(R.layout.fragment_checkout_wrapper_view, null) as FrameLayout

    init {
        val vParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )
        checkoutView.layoutParams = vParams
        //checkoutView.setBackgroundColor(Color.GREEN)
        methodChannel = MethodChannel(messenger, CHANNEL)
    }

    //private val textView: TextView
    override fun getView(): View {
        //return textView
        return checkoutView
    }

    override fun dispose() {}

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)

        Log.d(TAG, "onFlutterViewAttached")

        val fa = (checkoutView.context as MainActivity) as FragmentActivity
        val fm = fa.supportFragmentManager
        val checkoutFragment = initCheckoutFragment()
        fm.beginTransaction()
            .replace(R.id.checkout_fragment_container, checkoutFragment)
            .commitAllowingStateLoss()

        checkoutView.findViewById<FrameLayout>(R.id.checkout_fragment_container)
            ?.addOnLayoutChangeListener(
                CheckoutLayoutChangeListener { height ->
                    val density = checkoutView.context.resources.displayMetrics.density
                    val px = (height / density).toInt()
                    Log.d(TAG, "addOnLayoutChangeListener, height in px: $px")
                    methodChannel.invokeMethod(METHOD_CHECKOUT_HEIGHT, px)
                })
    }

    private fun initCheckoutFragment(): Fragment {
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

        return Checkout.init(
            context = view.context,
            builder = builder,
            //setupPreload = ApiTransactionDetails(amount = "12.12", ca),
            successCallback = {
                Log.e("TAG", "successCallback: $it")
                showResultDialog(view.context, it)
            },
            cancelCallback = {
                Log.e("TAG", "cancelCallback: $it")
                showResultDialog(view.context, it)
            },
            errorCallback = { errorData, throwable ->
                Log.e("TAG", "errorCallback: $errorData")
                showResultDialog(view.context, errorData, throwable)
            },
        )
    }

    private fun getCheckoutTheme(): CheckoutTheme {
        return CheckoutTheme(
            uiMode = CheckoutTheme.UiMode.DARK,
            showPaymentDetails = true,
            /*appearanceLight = CheckoutTheme.Appearance(
                sdkBackgroundColor = CheckoutTheme.Color(
                    Color.WHITE
                )
            ),*/
            appearanceDark = CheckoutTheme.Appearance(

            ),
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
