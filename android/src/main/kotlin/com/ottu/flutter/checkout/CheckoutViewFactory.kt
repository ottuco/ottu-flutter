package com.ottu.flutter.checkout

import android.content.Context
import android.content.res.Resources.NotFoundException
import android.util.Log
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.serialization.json.Json

private const val TAG = "CheckoutViewFactory"

class CheckoutViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private var engineGroup: FlutterEngineGroup? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>? ?: emptyMap()
        val creationParamsJson = creationParams["args"] as String?

        val checkoutArguments = creationParamsJson?.let {
            Json.decodeFromString(CheckoutArguments.serializer(), it)
        }
        if (checkoutArguments == null) {
            throw NotFoundException("There are no argument to start Checkout SDK")
        }

        val merchantWidgetRoute = (creationParams["merchantWidgetRoute"] as? String)
            ?.takeIf { it.isNotEmpty() }
        val nestedEngine = if (merchantWidgetRoute != null) {
            if (engineGroup == null) {
                engineGroup = FlutterEngineGroup(context.applicationContext)
            }
            val options = FlutterEngineGroup.Options(context)
                .setInitialRoute(merchantWidgetRoute)
            engineGroup?.createAndRunEngine(options)
        } else {
            null
        }

        Log.d(TAG, "create, with arguments")
        return CheckoutView(
            context = context,
            id = viewId,
            arguments = checkoutArguments,
            messenger = messenger,
            nestedEngine = nestedEngine,
        )
    }
}