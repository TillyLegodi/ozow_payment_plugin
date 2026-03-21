class CardValidationResult {
  final bool isValid;
  final String? errorMessage;

  const CardValidationResult({required this.isValid, this.errorMessage});
}

class OzowCardValidator {
  // ── Luhn Algorithm ─────────────────────────────────────
  /// Validates a card number using the Luhn algorithm.
  /// Works for Visa, Mastercard, Amex and most major cards.
  static bool luhnCheck(String cardNumber) {
    final digits = cardNumber.replaceAll(' ', '').replaceAll('-', '');
    if (digits.isEmpty) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = digits.length - 1; i >= 0; i--) {
      int digit = int.tryParse(digits[i]) ?? -1;
      if (digit == -1) return false;

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // ── Card Number ────────────────────────────────────────
  static CardValidationResult validateCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(' ', '').replaceAll('-', '');

    if (digits.isEmpty) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Card number is required',
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Card number must contain digits only',
      );
    }

    if (digits.length < 13 || digits.length > 19) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Card number must be between 13 and 19 digits',
      );
    }

    if (!luhnCheck(digits)) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Invalid card number',
      );
    }

    return const CardValidationResult(isValid: true);
  }

  // ── Expiry ─────────────────────────────────────────────
  static CardValidationResult validateExpiry(String month, String year) {
    if (month.isEmpty || year.isEmpty) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Expiry date is required',
      );
    }

    final monthInt = int.tryParse(month);
    final yearInt = int.tryParse(year);

    if (monthInt == null || monthInt < 1 || monthInt > 12) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Invalid expiry month (01–12)',
      );
    }

    if (yearInt == null) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Invalid expiry year',
      );
    }

    // Support both 2-digit and 4-digit year
    final fullYear = year.length == 2 ? 2000 + yearInt : yearInt;
    final now = DateTime.now();

    // ← FIXED: compare year and month directly, no DateTime month overflow
    if (fullYear < now.year || (fullYear == now.year && monthInt < now.month)) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Card has expired',
      );
    }

    if (fullYear > now.year + 20) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Expiry year is too far in the future',
      );
    }

    if (fullYear > now.year + 20) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Expiry year is too far in the future',
      );
    }

    return const CardValidationResult(isValid: true);
  }

  // ── CVV ────────────────────────────────────────────────
  static CardValidationResult validateCvv(String cvv, {bool isAmex = false}) {
    if (cvv.isEmpty) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'CVV is required',
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(cvv)) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'CVV must contain digits only',
      );
    }

    final expectedLength = isAmex ? 4 : 3;
    if (cvv.length != expectedLength) {
      return CardValidationResult(
        isValid: false,
        errorMessage: 'CVV must be $expectedLength digits',
      );
    }

    return const CardValidationResult(isValid: true);
  }

  // ── Cardholder Name ────────────────────────────────────
  static CardValidationResult validateCardholderName(String name) {
    if (name.trim().isEmpty) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Cardholder name is required',
      );
    }

    if (name.trim().length < 2) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Name is too short',
      );
    }

    if (name.trim().length > 64) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Name is too long',
      );
    }

    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(name.trim())) {
      return const CardValidationResult(
        isValid: false,
        errorMessage: 'Name must contain letters only',
      );
    }

    return const CardValidationResult(isValid: true);
  }

  // ── Card Type Detection ────────────────────────────────
  static String detectCardType(String cardNumber) {
    final digits = cardNumber.replaceAll(' ', '');
    if (digits.isEmpty) return 'unknown';

    if (RegExp(r'^4').hasMatch(digits)) return 'visa';
    if (RegExp(r'^5[1-5]').hasMatch(digits)) return 'mastercard';
    if (RegExp(r'^2[2-7]').hasMatch(digits)) return 'mastercard';
    if (RegExp(r'^3[47]').hasMatch(digits)) return 'amex';
    if (RegExp(r'^6(?:011|5)').hasMatch(digits)) return 'discover';

    return 'unknown';
  }

  // ── Validate All Fields At Once ────────────────────────
  static Map<String, CardValidationResult> validateAll({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardholderName,
  }) {
    final cardType = detectCardType(cardNumber);
    final isAmex = cardType == 'amex';

    return {
      'cardNumber': validateCardNumber(cardNumber),
      'expiry': validateExpiry(expiryMonth, expiryYear),
      'cvv': validateCvv(cvv, isAmex: isAmex),
      'cardholderName': validateCardholderName(cardholderName),
    };
  }

  // ── Quick Check — all fields valid ─────────────────────
  static bool isAllValid({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardholderName,
  }) {
    final results = validateAll(
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
      cardholderName: cardholderName,
    );
    return results.values.every((r) => r.isValid);
  }
}
