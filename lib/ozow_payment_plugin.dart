// ── Exports ─────────────────────────────────────────────
export 'src/ozow_config.dart';
export 'src/ozow_result.dart';
export 'src/ozow_card_validator.dart';
export 'src/widgets/ozow_button.dart';
export 'src/widgets/ozow_payment_sheet.dart';
export 'src/widgets/ozow_loading_screen.dart';
export 'src/widgets/ozow_result_screen.dart';
export 'src/widgets/payment_method_selector.dart';

// ── Imports ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'src/ozow_config.dart';
import 'src/ozow_result.dart';
import 'src/widgets/ozow_payment_sheet.dart';

// ── Main Plugin API ──────────────────────────────────────
class OzowPaymentPlugin {
  /// Launch the Ozow payment sheet.
  ///
  /// Returns an [OzowResult] with the payment outcome.
  ///
  /// Example:
  /// ```dart
  /// final result = await OzowPaymentPlugin.startPayment(
  ///   context: context,
  ///   config: OzowConfig(
  ///     siteCode: 'SITE_CODE',
  ///     privateKey: 'PRIVATE_KEY',
  ///     apiKey: 'API_KEY',
  ///     amount: 150.00,
  ///     transactionReference: 'ORDER-001',
  ///     bankReference: 'My Shop',
  ///   ),
  /// );
  /// if (result.isSuccess) { // done! }
  /// ```
  static Future<OzowResult> startPayment({
    required BuildContext context,
    required OzowConfig config,
  }) async {
    OzowResult? result;

    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            OzowPaymentSheet(config: config, onResult: (r) => result = r),
      ),
    );

    return result ?? const OzowResult(status: OzowPaymentStatus.cancelled);
  }
}
