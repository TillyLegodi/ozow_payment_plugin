import Flutter
import UIKit

public class OzowPaymentPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // WebView handles all payment processing
        // No method channel needed for Ozow WebView integration
    }
}