package com.otto.sample

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

class PlatformViewPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        binding
            .platformViewRegistry
            .registerViewFactory(
                "CheckoutPlatformView",
                CheckoutViewFactory(binding.binaryMessenger)
            )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
}