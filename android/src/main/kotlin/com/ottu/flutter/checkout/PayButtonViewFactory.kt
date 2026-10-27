package com.ottu.flutter.checkout

import android.content.Context
import android.content.ContextWrapper
import android.view.LayoutInflater
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.widget.FrameLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.setViewTreeLifecycleOwner
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

private const val TAG = "PayButtonViewFactory"
private const val METHOD_PAY_BUTTON_HEIGHT = "METHOD_PAY_BUTTON_HEIGHT"

internal class PayButtonViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView =
        PayButtonView(context, viewId, messenger)
}

private class PayButtonView(context: Context, viewId: Int, messenger: BinaryMessenger) : PlatformView {
    private val channel = MethodChannel(messenger, "com.ottu.flutter.checkout/pay_button/$viewId")
    private val button = LayoutInflater.from(context).inflate(R.layout.pay_button_view, null)
    private var lastHeight: Double? = null
    private val container = object : FrameLayout(context) {
        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            // Flutter constrains the host to the last reported height. Measure the
            // content independently so it can grow again after being collapsed.
            super.onMeasure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED))
            setMeasuredDimension(measuredWidth, resolveSize(measuredHeight, heightMeasureSpec))
        }
    }.apply {
        val owner = generateSequence(context) { current ->
            (current as? ContextWrapper)?.baseContext?.takeIf { it !== current }
        }.filterIsInstance<LifecycleOwner>().firstOrNull()
        requireNotNull(owner) { "PayButtonWidget requires a LifecycleOwner activity" }
        setViewTreeLifecycleOwner(owner)
        addView(
            button,
            FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT,
            ),
        )
    }
    // Visibility can change without changing the host's bounds, so observe the
    // whole layout pass rather than only the host's OnLayoutChangeListener.
    private val layoutListener = ViewTreeObserver.OnGlobalLayoutListener {
        val height = buttonHeight()
        Log.d(
            TAG,
            "OnGlobalLayoutListener, height has been changed, height: $height, lastHeight: $lastHeight"
        )
        if (height != lastHeight) {
            lastHeight = height
            channel.invokeMethod(METHOD_PAY_BUTTON_HEIGHT, height)
        }
    }

    init {
        container.viewTreeObserver.addOnGlobalLayoutListener(layoutListener)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                METHOD_PAY_BUTTON_HEIGHT -> result.success(buttonHeight())
                else -> result.notImplemented()
            }
        }
    }

    private fun buttonHeight(): Double =
        if (button.visibility == View.GONE) 0.0
        else button.measuredHeight.toDouble() / container.resources.displayMetrics.density

    override fun getView(): View = container

    override fun dispose() {
        container.viewTreeObserver.takeIf { it.isAlive }
            ?.removeOnGlobalLayoutListener(layoutListener)
        channel.setMethodCallHandler(null)
        // Detachment cancels observation without releasing the active checkout.
        container.removeAllViews()
        container.setViewTreeLifecycleOwner(null)
    }
}
