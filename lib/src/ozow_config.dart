class OzowConfig {
  final String siteCode;
  final String privateKey;
  final String apiKey;
  final double amount;
  final String transactionReference;
  final String bankReference;
  final String? cancelUrl;
  final String? errorUrl;
  final String? successUrl;
  final String? notifyUrl;
  final bool isTest;
  final String? hashCheck;

  /// Optional: pre-select a bank or payment method.
  /// For PayShap standalone button use:
  /// selectedBankId: OzowBankIds.payShap
  final String? selectedBankId;

  /// Optional: customer cellphone number.
  /// Ozow will pre-populate it on the PayShap screen
  /// saving the user time. DO NOT include in hash check.
  final String? customerCellphoneNumber;

  const OzowConfig({
    required this.siteCode,
    required this.privateKey,
    required this.apiKey,
    required this.amount,
    required this.transactionReference,
    required this.bankReference,
    this.cancelUrl,
    this.errorUrl,
    this.successUrl,
    this.notifyUrl,
    this.isTest = false,
    this.hashCheck,
    this.selectedBankId,
    this.customerCellphoneNumber,
  });
}

/// Ozow Bank IDs for direct bank/method selection
class OzowBankIds {
  /// Takes user directly to PayShap bank selection screen
  static const String payShap = 'EEC08676-46EB-4F80-AF56-CAA5A6623880';

  /// Standard Bank
  static const String standardBank = 'standardbank';

  /// FNB
  static const String fnb = 'fnb';

  /// Absa
  static const String absa = 'absa';

  /// Capitec
  static const String capitec = 'capitec';

  /// Nedbank
  static const String nedbank = 'nedbank';

  /// Discovery Bank
  static const String discoveryBank = 'discoverybank';

  /// TymeBank
  static const String tymeBank = 'tymebank';
}
