#ifndef FLUTTER_PLUGIN_OZOW_PAYMENT_PLUGIN_H_
#define FLUTTER_PLUGIN_OZOW_PAYMENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace ozow_payment_plugin {

class OzowPaymentPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  OzowPaymentPlugin();

  virtual ~OzowPaymentPlugin();

  // Disallow copy and assign.
  OzowPaymentPlugin(const OzowPaymentPlugin&) = delete;
  OzowPaymentPlugin& operator=(const OzowPaymentPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace ozow_payment_plugin

#endif  // FLUTTER_PLUGIN_OZOW_PAYMENT_PLUGIN_H_
