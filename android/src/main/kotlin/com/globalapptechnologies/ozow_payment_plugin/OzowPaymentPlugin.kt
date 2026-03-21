package com.globalapptechnologies.ozow_payment_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin

class OzowPaymentPlugin : FlutterPlugin {
    // WebView handles all payment processing
    // No method channel needed for Ozow WebView integration

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // No native channels required
        // All payment flow is handled via webview_flutter
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Nothing to clean up
    }
}