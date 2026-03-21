import 'package:flutter_test/flutter_test.dart';
import 'package:ozow_payment_plugin/ozow_payment_plugin.dart';
import 'package:ozow_payment_plugin/src/ozow_hash_service.dart';

void main() {
  group('OzowConfig', () {
    test('creates with required fields correctly', () {
      const config = OzowConfig(
        siteCode: 'TEST001',
        privateKey: 'PRIVATE_KEY',
        apiKey: 'API_KEY',
        amount: 150.00,
        transactionReference: 'ORDER-001',
        bankReference: 'Test Shop',
      );

      expect(config.siteCode, 'TEST001');
      expect(config.amount, 150.00);
      expect(config.isTest, false);
      expect(config.notifyUrl, null);
    });

    test('isTest defaults to false', () {
      const config = OzowConfig(
        siteCode: 'TEST001',
        privateKey: 'PRIVATE_KEY',
        apiKey: 'API_KEY',
        amount: 50.00,
        transactionReference: 'ORDER-002',
        bankReference: 'Test Shop',
      );
      expect(config.isTest, false);
    });
  });

  group('OzowResult', () {
    test('isSuccess is true for success status', () {
      const result = OzowResult(status: OzowPaymentStatus.success);
      expect(result.isSuccess, true);
      expect(result.isCancelled, false);
      expect(result.isError, false);
      expect(result.isPending, false);
    });

    test('isCancelled is true for cancelled status', () {
      const result = OzowResult(status: OzowPaymentStatus.cancelled);
      expect(result.isCancelled, true);
      expect(result.isSuccess, false);
    });

    test('isError is true for error status', () {
      const result = OzowResult(
        status: OzowPaymentStatus.error,
        errorMessage: 'Insufficient funds',
      );
      expect(result.isError, true);
      expect(result.errorMessage, 'Insufficient funds');
    });

    test('isPending is true for pending status', () {
      const result = OzowResult(status: OzowPaymentStatus.pending);
      expect(result.isPending, true);
      expect(result.isSuccess, false);
    });

    test('toString returns readable string', () {
      const result = OzowResult(
        status: OzowPaymentStatus.success,
        transactionId: 'TXN-123',
        reference: 'ORDER-001',
      );
      expect(result.toString(), contains('success'));
      expect(result.toString(), contains('TXN-123'));
    });
  });
  group('OzowCardValidator - Luhn Algorithm', () {
    test('valid Visa card passes Luhn check', () {
      expect(OzowCardValidator.luhnCheck('4111111111111111'), true);
    });

    test('valid Mastercard passes Luhn check', () {
      expect(OzowCardValidator.luhnCheck('5500005555555559'), true);
    });

    test('invalid card fails Luhn check', () {
      expect(OzowCardValidator.luhnCheck('1234567890123456'), false);
    });

    test('tampered card number fails Luhn check', () {
      expect(OzowCardValidator.luhnCheck('4111111111111112'), false);
    });
  });

  group('OzowCardValidator - Card Number', () {
    test('valid card number passes', () {
      final result = OzowCardValidator.validateCardNumber('4111111111111111');
      expect(result.isValid, true);
    });

    test('empty card number fails', () {
      final result = OzowCardValidator.validateCardNumber('');
      expect(result.isValid, false);
      expect(result.errorMessage, 'Card number is required');
    });

    test('too short card number fails', () {
      final result = OzowCardValidator.validateCardNumber('411111');
      expect(result.isValid, false);
    });

    test('card number with letters fails', () {
      final result = OzowCardValidator.validateCardNumber('4111abcd11111111');
      expect(result.isValid, false);
    });
  });

  group('OzowCardValidator - Expiry', () {
    test('valid future expiry passes', () {
      final now = DateTime.now();
      final futureYear = (now.year + 2).toString();
      final result = OzowCardValidator.validateExpiry('12', futureYear);
      expect(result.isValid, true);
    });

    test('expired card fails', () {
      final result = OzowCardValidator.validateExpiry('01', '2020');
      expect(result.isValid, false);
      expect(result.errorMessage, 'Card has expired');
    });

    test('invalid month fails', () {
      final result = OzowCardValidator.validateExpiry('13', '2099');
      expect(result.isValid, false);
    });

    test('empty expiry fails', () {
      final result = OzowCardValidator.validateExpiry('', '');
      expect(result.isValid, false);
    });
  });

  group('OzowCardValidator - CVV', () {
    test('valid 3-digit CVV passes', () {
      final result = OzowCardValidator.validateCvv('123');
      expect(result.isValid, true);
    });

    test('valid 4-digit Amex CVV passes', () {
      final result = OzowCardValidator.validateCvv('1234', isAmex: true);
      expect(result.isValid, true);
    });

    test('wrong length CVV fails', () {
      final result = OzowCardValidator.validateCvv('12');
      expect(result.isValid, false);
    });

    test('empty CVV fails', () {
      final result = OzowCardValidator.validateCvv('');
      expect(result.isValid, false);
    });
  });

  group('OzowCardValidator - Luhn Algorithm', () {
    test('valid Visa card passes Luhn check', () {
      expect(OzowCardValidator.luhnCheck('4111111111111111'), true);
    });

    test('valid Mastercard passes Luhn check', () {
      expect(OzowCardValidator.luhnCheck('5500005555555559'), true);
    });

    test('invalid card fails Luhn check', () {
      expect(OzowCardValidator.luhnCheck('1234567890123456'), false);
    });

    // ← FIXED: 0000000000000000 actually passes Luhn mathematically
    // Use a genuinely invalid number instead
    test('tampered card number fails Luhn check', () {
      expect(OzowCardValidator.luhnCheck('4111111111111112'), false);
    });
  });
  group('OzowHashService', () {
    test('generates consistent hash for same inputs', () {
      final hash1 = OzowHashService.generateHash(
        siteCode: 'TEST001',
        countryCode: 'ZA',
        currencyCode: 'ZAR',
        amount: 10.00,
        transactionReference: 'ORDER-001',
        bankReference: 'Test Shop',
        cancelUrl: 'https://pay.ozow.com/cancel',
        errorUrl: 'https://pay.ozow.com/error',
        successUrl: 'https://pay.ozow.com/success',
        isTest: false,
        privateKey: 'TEST_PRIVATE_KEY',
      );

      final hash2 = OzowHashService.generateHash(
        siteCode: 'TEST001',
        countryCode: 'ZA',
        currencyCode: 'ZAR',
        amount: 10.00,
        transactionReference: 'ORDER-001',
        bankReference: 'Test Shop',
        cancelUrl: 'https://pay.ozow.com/cancel',
        errorUrl: 'https://pay.ozow.com/error',
        successUrl: 'https://pay.ozow.com/success',
        isTest: false,
        privateKey: 'TEST_PRIVATE_KEY',
      );

      // Same inputs must always produce same hash
      expect(hash1, equals(hash2));
      // Hash must be 128 characters (SHA512)
      expect(hash1.length, equals(128));
    });
  });
}
