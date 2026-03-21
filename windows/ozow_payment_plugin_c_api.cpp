#include "include/ozow_payment_plugin/ozow_payment_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ozow_payment_plugin.h"

void OzowPaymentPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ozow_payment_plugin::OzowPaymentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
