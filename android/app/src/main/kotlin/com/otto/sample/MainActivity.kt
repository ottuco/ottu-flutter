package com.ottu.sample

import android.app.AlertDialog
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup
import android.widget.FrameLayout
import com.otto.sample.CheckoutViewFactory
import com.ottu.checkout.Checkout
import com.ottu.checkout.ui.theme.CheckoutTheme
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


private const val TAG = "MainActivity"
private const val OTTU_FRAGMENT_ID = 0x123456

private val merchantId = "alpha.ottu.net"
private val apiKey = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI"
const val CHANNEL = "com.ottu.sample/checkout"

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.ottu.sample/checkout"
    private val METHOD_LAUNCH_OTTU = "launchOttuSdk"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        /* if (savedInstanceState != null) {
             checkoutFragment =
                 supportFragmentManager.findFragmentById(OTTU_FRAGMENT_ID) as CheckoutSdkFragment?
         } else {
             initSdk()
         }*/

        val vParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )

        val container = FrameLayout(this)
        /*       val density = resources.displayMetrics.density
               val paddingPixel = (72 * density).toInt()
              container.setPadding(0, paddingPixel, 0, 0);
              container.layoutParams = vParams*/
        container.id = OTTU_FRAGMENT_ID
        //addContentView(container, vParams)

    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "CheckoutPlatformView",
                CheckoutViewFactory(flutterEngine.dartExecutor.binaryMessenger)
            )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            Log.d(TAG, "CallHandler, call: $call")
            if (call.method == METHOD_LAUNCH_OTTU) {
                initSdk(this@MainActivity)
                /*if (checkoutFragment != null) {
                    Log.d(TAG, "CallHandler, add CheckoutSdkFragment")
                    val fm = supportFragmentManager
                    fm.beginTransaction()
                        .replace(OTTU_FRAGMENT_ID, checkoutFragment)
                        .commitAllowingStateLoss()

                    checkoutFragment.view?.also {
                        it.setBackgroundColor(Color.WHITE)
                        val vParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
                            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT
                        )
                        vParams.gravity = Gravity.BOTTOM
                        it.layoutParams = vParams
                    }
                    result.success(null)
                } else {
                    result.error("911", "Unable to instantiate CheckoutSdkFragment", null)
                }*/
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun initSdk(context: Context) {
        /*if (merchantId.isNullOrEmpty()) {
            Toast.makeText(this, "Merchant ID cannot be null or empty", Toast.LENGTH_SHORT).show()
            return
        }

        if (apiKey.isNullOrEmpty()) {
            Toast.makeText(this, "API Key cannot be null or empty", Toast.LENGTH_SHORT).show()
            return
        }

        if (amount == null || amount!! <= 0) {
            Toast.makeText(this, "Amount cannot be null or <= 0", Toast.LENGTH_SHORT).show()
            return
        }

        if (sessionId.isNullOrEmpty()) {
            Toast.makeText(this, "SessionId cannot be null or <= 0", Toast.LENGTH_SHORT).show()
            return
        }*/

        initSdk(
            context = context,
            sessionId = "272e054a08ff73a2b4582bd55839cfdae5821f74",
            formsOfPayment = listOf(
                Checkout.FormsOfPayment.GooglePay,
                Checkout.FormsOfPayment.OttuPG,
                Checkout.FormsOfPayment.DirectPayment,
                Checkout.FormsOfPayment.TokenPay,
            )
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
                showResultDialog(it)
            },
            cancelCallback = {
                Log.e("TAG", "cancelCallback: $it")
                showResultDialog(it)
            },
            errorCallback = { errorData, throwable ->
                Log.e("TAG", "errorCallback: $errorData")
                showResultDialog(errorData, throwable)
            },
        )
    }

    private fun showResultDialog(result: JSONObject?, throwable: Throwable? = null) {
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

        AlertDialog.Builder(this)
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
