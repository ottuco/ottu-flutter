package com.ottu.flutter.checkout

import android.content.Context
import android.content.res.Resources.NotFoundException
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.serialization.json.Json

private const val TAG = "CheckoutViewFactory"

class CheckoutViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>? ?: emptyMap()
        val creationParamsJson = creationParams["args"] as String?

        val checkoutArguments = creationParamsJson?.let {
            Json.decodeFromString(CheckoutArguments.serializer(), it)
        }
        if (checkoutArguments == null) {
            throw NotFoundException("There are no argument to start Checkout SDK")
        }
        Log.d(TAG, "create, with arguments: $checkoutArguments")
        return CheckoutView(
            context = context,
            id = viewId,
            arguments = checkoutArguments,
            messenger = messenger
        )
    }
}