import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ozow_payment_plugin/ozow_payment_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('OzowConfig builds without errors', (WidgetTester tester) async {
    final config = OzowConfig(
      siteCode: 'TEST_SITE_CODE',
      privateKey: 'TEST_PRIVATE_KEY',
      apiKey: 'TEST_API_KEY',
      amount: 150.00,
      transactionReference: 'TEST-001',
      bankReference: 'Test Shop',
      isTest: false,
    );

    expect(config.siteCode, 'TEST_SITE_CODE');
    expect(config.amount, 150.00);
    expect(config.isTest, false);
  });

  testWidgets('OzowResult reports correct status', (WidgetTester tester) async {
    const successResult = OzowResult(
      // ← added const
      status: OzowPaymentStatus.success,
      transactionId: 'TXN-123',
      reference: 'ORDER-001',
    );
    expect(successResult.isSuccess, true);
    expect(successResult.isCancelled, false);
    expect(successResult.isError, false);

    const cancelledResult = OzowResult(status: OzowPaymentStatus.cancelled);
    expect(cancelledResult.isCancelled, true);
    expect(cancelledResult.isSuccess, false);

    const errorResult = OzowResult(
      status: OzowPaymentStatus.error,
      errorMessage: 'Insufficient funds',
    );
    expect(errorResult.isError, true);
    expect(errorResult.errorMessage, 'Insufficient funds');
  });
}
