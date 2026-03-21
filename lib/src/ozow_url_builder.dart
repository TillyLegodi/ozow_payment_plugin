import 'ozow_config.dart';
import 'ozow_hash_service.dart';

class OzowUrlBuilder {
  static const String _baseUrl = 'https://pay.ozow.com/';
  static const String _countryCode = 'ZA';
  static const String _currencyCode = 'ZAR';

  static const String _defaultCancelUrl = 'https://pay.ozow.com/cancel';
  static const String _defaultErrorUrl = 'https://pay.ozow.com/error';
  static const String _defaultSuccessUrl = 'https://pay.ozow.com/success';

  static String build(OzowConfig config) {
    final resolvedCancelUrl = config.cancelUrl ?? _defaultCancelUrl;
    final resolvedErrorUrl = config.errorUrl ?? _defaultErrorUrl;
    final resolvedSuccessUrl = config.successUrl ?? _defaultSuccessUrl;

    final hash =
        config.hashCheck ??
        OzowHashService.generateHash(
          siteCode: config.siteCode,
          countryCode: _countryCode,
          currencyCode: _currencyCode,
          amount: config.amount,
          transactionReference: config.transactionReference,
          bankReference: config.bankReference,
          cancelUrl: resolvedCancelUrl,
          errorUrl: resolvedErrorUrl,
          successUrl: resolvedSuccessUrl,
          notifyUrl: config.notifyUrl,
          isTest: config.isTest,
          privateKey: config.privateKey,
        );

    final params = <String, String>{
      'SiteCode': config.siteCode,
      'CountryCode': _countryCode,
      'CurrencyCode': _currencyCode,
      'Amount': config.amount.toStringAsFixed(2),
      'TransactionReference': config.transactionReference,
      'BankReference': config.bankReference,
      'CancelUrl': resolvedCancelUrl,
      'ErrorUrl': resolvedErrorUrl,
      'SuccessUrl': resolvedSuccessUrl,
      'IsTest': config.isTest ? 'true' : 'false',
      'HashCheck': hash,
      if (config.notifyUrl != null) 'NotifyUrl': config.notifyUrl!,
      // SelectedBankId — NOT in hash, URL param only
      if (config.selectedBankId != null)
        'SelectedBankId': config.selectedBankId!,
      if (config.customerCellphoneNumber != null)
        'CustomerCellphoneNumber': config.customerCellphoneNumber!,
    };

    return Uri.parse(_baseUrl).replace(queryParameters: params).toString();
  }
}
