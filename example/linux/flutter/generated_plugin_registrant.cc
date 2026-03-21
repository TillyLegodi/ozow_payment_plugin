//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ozow_payment_plugin/ozow_payment_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ozow_payment_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OzowPaymentPlugin");
  ozow_payment_plugin_register_with_registrar(ozow_payment_plugin_registrar);
}
