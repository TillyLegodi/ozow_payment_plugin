import 'dart:convert';
import 'package:crypto/crypto.dart';

class OzowHashService {
  static String generateHash({
    required String siteCode,
    required String countryCode,
    required String currencyCode,
    required double amount,
    required String transactionReference,
    required String bankReference,
    required String cancelUrl,
    required String errorUrl,
    required String successUrl,
    required bool isTest,
    required String privateKey,
    String? notifyUrl,
  }) {
    // ── Exact order from Ozow documentation ─────────────
    // SiteCode + CountryCode + CurrencyCode + Amount
    // + TransactionReference + BankReference
    // + CancelUrl + ErrorUrl + SuccessUrl
    // + NotifyUrl (only if provided)
    // + IsTest + PrivateKey
    final buffer = StringBuffer()
      ..write(siteCode)
      ..write(countryCode)
      ..write(currencyCode)
      ..write(amount.toStringAsFixed(2))
      ..write(transactionReference)
      ..write(bankReference)
      ..write(cancelUrl)
      ..write(errorUrl)
      ..write(successUrl);

    if (notifyUrl != null && notifyUrl.isNotEmpty) {
      buffer.write(notifyUrl);
    }

    buffer
      ..write(isTest ? 'true' : 'false')
      ..write(privateKey);

    final lowercased = buffer.toString().toLowerCase();
    final bytes = utf8.encode(lowercased);
    return sha512.convert(bytes).toString();
  }
}
