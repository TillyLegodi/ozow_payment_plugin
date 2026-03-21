import 'package:flutter/material.dart';
import 'package:ozow_payment_plugin/ozow_payment_plugin.dart';

// ╔══════════════════════════════════════════════════════════════════╗
// ║           OZOW PAYMENT PLUGIN — DEVELOPER GUIDE                 ║
// ╠══════════════════════════════════════════════════════════════════╣
// ║                                                                  ║
// ║  STEP 1 — ADD YOUR OZOW CREDENTIALS                             ║
// ║  Replace the placeholder values in OzowConfig below:            ║
// ║    • siteCode    → from your Ozow Merchant Dashboard            ║
// ║    • privateKey  → from your Ozow Merchant Dashboard            ║
// ║    • apiKey      → from your Ozow Merchant Dashboard            ║
// ║                                                                  ║
// ║  STEP 2 — PASS YOUR DYNAMIC AMOUNT                              ║
// ║  The `amount` field accepts any double value. Examples:          ║
// ║                                                                  ║
// ║  // From a cart total:                                           ║
// ║  amount: cartService.total,                                      ║
// ║                                                                  ║
// ║  // From a wallet top-up input:                                  ║
// ║  amount: double.parse(walletAmountController.text),              ║
// ║                                                                  ║
// ║  // From an API/order response:                                  ║
// ║  amount: order.totalAmount,                                      ║
// ║                                                                  ║
// ║  // From a subscription plan:                                    ║
// ║  amount: selectedPlan.price,                                     ║
// ║                                                                  ║
// ║  STEP 3 — SET YOUR BANK REFERENCE                               ║
// ║  This is what appears on the customer's bank statement:          ║
// ║  bankReference: 'Your Store Name',                               ║
// ║                                                                  ║
// ║  STEP 4 — HANDLE THE RESULT                                     ║
// ║  result.isSuccess   → payment completed                          ║
// ║  result.isCancelled → user closed the payment sheet             ║
// ║  result.isError     → payment failed                             ║
// ║  result.transactionId → Ozow transaction reference              ║
// ║                                                                  ║
// ║  STEP 5 — TRANSACTION REFERENCE                                  ║
// ║  Must be unique per payment. Examples:                           ║
// ║                                                                  ║
// ║  // Timestamp based (simplest):                                  ║
// ║  transactionReference: 'ORDER-${DateTime.now()                   ║
// ║    .millisecondsSinceEpoch}',                                    ║
// ║                                                                  ║
// ║  // From your order/database ID:                                 ║
// ║  transactionReference: 'ORDER-${order.id}',                      ║
// ║                                                                  ║
// ║  // For wallet top-ups:                                          ║
// ║  transactionReference: 'WALLET-${user.id}-${timestamp}',         ║
// ║                                                                  ║
// ║  STEP 6 — TEST MODE                                              ║
// ║  Set isTest: true while developing and testing.                  ║
// ║  Set isTest: false for production/live payments.                 ║
// ║                                                                  ║
// ║  STEP 7 — REDIRECT URLS (RECOMMENDED)                           ║
// ║  Always pass explicit URLs that match your Ozow                  ║
// ║  Merchant Dashboard under Sites → URLs:                          ║
// ║  cancelUrl:  'https://yourdomain.com/cancel'                     ║
// ║  errorUrl:   'https://yourdomain.com/error'                      ║
// ║  successUrl: 'https://yourdomain.com/success'                    ║
// ║  notifyUrl:  'https://yourdomain.com/notify' (webhook)           ║
// ║                                                                  ║
// ╠══════════════════════════════════════════════════════════════════╣
// ║              ⚡ STEP 8 — PAYSHAP INTEGRATION ⚡                  ║
// ╠══════════════════════════════════════════════════════════════════╣
// ║                                                                  ║
// ║  PayShap is South Africa's instant real-time payment             ║
// ║  system powered by BankservAfrica. Customers pay                 ║
// ║  using just their mobile number or bank account                  ║
// ║  number — no card or banking credentials needed.                 ║
// ║                                                                  ║
// ║  ⚠️  ACTIVATION REQUIRED BEFORE USE:                            ║
// ║  ─────────────────────────────────────────────────               ║
// ║  PayShap standalone button requires Ozow to activate             ║
// ║  it on your specific merchant account first.                     ║
// ║                                                                  ║
// ║  Contact Ozow to get it enabled on your account:                 ║
// ║    📧 Email:   support@ozow.com                                  ║
// ║    💬 Subject: Enable PayShap Request — [YOUR SITE CODE]         ║
// ║    🌐 Portal:  hub.ozow.com                                      ║
// ║                                                                  ║
// ║  In your email, include:                                         ║
// ║    • Your Ozow Site Code                                         ║
// ║    • Your business name                                          ║
// ║    • "Please enable PayShap Request standalone                   ║
// ║       button on my merchant account"                             ║
// ║                                                                  ║
// ║  HOW PAYSHAP WORKS FOR YOUR CUSTOMERS:                           ║
// ║  ─────────────────────────────────────────────────               ║
// ║  1. Customer taps PayShap button                                 ║
// ║  2. Selects their bank (Standard Bank, FNB, Absa,                ║
// ║     Capitec, Discovery Bank, TymeBank etc.)                      ║
// ║  3. Enters mobile number or bank account number                  ║
// ║  4. Authorises payment in their banking app                      ║
// ║  5. Payment confirmed instantly — real time!                     ║
// ║                                                                  ║
// ║  PAYSHAP CONFIG FIELDS:                                          ║
// ║  ─────────────────────────────────────────────────               ║
// ║  selectedBankId: OzowBankIds.payShap                             ║
// ║  → Passes SelectedBankId EEC08676-46EB-4F80-                    ║
// ║    AF56-CAA5A6623880 to Ozow. Takes user directly                ║
// ║    to PayShap bank selection. NOT in hash check.                 ║
// ║                                                                  ║
// ║  customerCellphoneNumber: '0821234567' (optional)                ║
// ║  → Pre-fills customer phone on PayShap screen.                   ║
// ║    Saves user time. NOT included in hash check.                  ║
// ║                                                                  ║
// ╠══════════════════════════════════════════════════════════════════╣
// ║                  FULL INTEGRATION EXAMPLES                       ║
// ╠══════════════════════════════════════════════════════════════════╣
// ║                                                                  ║
// ║  EXAMPLE 1 — CARD PAYMENT (E-COMMERCE CART):                    ║
// ║  ─────────────────────────────────────────────────               ║
// ║  final result = await OzowPaymentPlugin.startPayment(            ║
// ║    context: context,                                             ║
// ║    config: OzowConfig(                                           ║
// ║      siteCode: 'YOUR_SITE_CODE',                                 ║
// ║      privateKey: 'YOUR_PRIVATE_KEY',                             ║
// ║      apiKey: 'YOUR_API_KEY',                                     ║
// ║      amount: cart.totalAmount,   // ← dynamic cart total        ║
// ║      transactionReference: 'ORDER-${order.id}',                  ║
// ║      bankReference: 'My Store',                                  ║
// ║      cancelUrl: 'https://yourdomain.com/cancel',                 ║
// ║      errorUrl: 'https://yourdomain.com/error',                   ║
// ║      successUrl: 'https://yourdomain.com/success',               ║
// ║      isTest: false,                                              ║
// ║    ),                                                            ║
// ║  );                                                              ║
// ║  if (result.isSuccess) {                                         ║
// ║    // navigate to success screen                                 ║
// ║  } else if (result.isCancelled) {                                ║
// ║    // user closed the payment sheet                              ║
// ║  } else if (result.isError) {                                    ║
// ║    // show error: result.errorMessage                            ║
// ║  }                                                               ║
// ║                                                                  ║
// ║  EXAMPLE 2 — PAYSHAP DIRECT (AFTER OZOW ACTIVATION):            ║
// ║  ─────────────────────────────────────────────────               ║
// ║  final result = await OzowPaymentPlugin.startPayment(            ║
// ║    context: context,                                             ║
// ║    config: OzowConfig(                                           ║
// ║      siteCode: 'YOUR_SITE_CODE',                                 ║
// ║      privateKey: 'YOUR_PRIVATE_KEY',                             ║
// ║      apiKey: 'YOUR_API_KEY',                                     ║
// ║      amount: cart.totalAmount,                                   ║
// ║      transactionReference: 'ORDER-${order.id}',                  ║
// ║      bankReference: 'My Store',                                  ║
// ║      cancelUrl: 'https://yourdomain.com/cancel',                 ║
// ║      errorUrl: 'https://yourdomain.com/error',                   ║
// ║      successUrl: 'https://yourdomain.com/success',               ║
// ║      selectedBankId: OzowBankIds.payShap,                        ║
// ║      customerCellphoneNumber: '0821234567', // ← optional       ║
// ║      isTest: false,                                              ║
// ║    ),                                                            ║
// ║  );                                                              ║
// ║                                                                  ║
// ║  EXAMPLE 3 — WALLET TOP-UP:                                      ║
// ║  ─────────────────────────────────────────────────               ║
// ║  final result = await OzowPaymentPlugin.startPayment(            ║
// ║    context: context,                                             ║
// ║    config: OzowConfig(                                           ║
// ║      siteCode: 'YOUR_SITE_CODE',                                 ║
// ║      privateKey: 'YOUR_PRIVATE_KEY',                             ║
// ║      apiKey: 'YOUR_API_KEY',                                     ║
// ║      amount: topUpAmount,        // ← user entered amount       ║
// ║      transactionReference: 'WALLET-${DateTime.now()             ║
// ║        .millisecondsSinceEpoch}',                                ║
// ║      bankReference: 'Wallet Top-Up',                             ║
// ║      isTest: false,                                              ║
// ║    ),                                                            ║
// ║  );                                                              ║
// ║                                                                  ║
// ║  EXAMPLE 4 — SUBSCRIPTION:                                       ║
// ║  ─────────────────────────────────────────────────               ║
// ║  final result = await OzowPaymentPlugin.startPayment(            ║
// ║    context: context,                                             ║
// ║    config: OzowConfig(                                           ║
// ║      siteCode: 'YOUR_SITE_CODE',                                 ║
// ║      privateKey: 'YOUR_PRIVATE_KEY',                             ║
// ║      apiKey: 'YOUR_API_KEY',                                     ║
// ║      amount: plan.monthlyPrice,  // ← plan price                ║
// ║      transactionReference: 'SUB-${user.id}-${plan.id}',         ║
// ║      bankReference: 'Monthly Subscription',                      ║
// ║      isTest: false,                                              ║
// ║    ),                                                            ║
// ║  );                                                              ║
// ║                                                                  ║
// ║  🔐 SECURITY NOTE:                                               ║
// ║  Never hardcode your privateKey in production apps.              ║
// ║  Generate the hash on your backend server and pass               ║
// ║  it via: hashCheck: yourBackend.generatedHash                    ║
// ║  This keeps your private key off the device entirely.            ║
// ║  See README.md for backend hash generation examples.             ║
// ║                                                                  ║
// ╚══════════════════════════════════════════════════════════════════╝

void main() => runApp(const OzowExampleApp());

class OzowExampleApp extends StatelessWidget {
  const OzowExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ozow Payment Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1ABFA1),
        useMaterial3: true,
      ),
      home: const CheckoutScreen(),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  OzowResult? _lastResult;
  bool _loading = false;

  // ── Step 1: Show payment method selector ────────────
  // User picks Card or PayShap — then Ozow launches
  Future<void> _pay() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: OzowPaymentMethodSelector(
            merchantName: 'My Ozow Shop',
            amount: 10.00, // ← Step 2: replace with dynamic amount
            onMethodSelected: (method) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 300));
              await _launchOzow(method);
            },
          ),
        ),
      ),
    );
  }

  // ── Step 2: Launch Ozow with correct payment method ──
  // Card    → opens full Ozow payment page
  // PayShap → goes directly to PayShap bank selection
  //           ⚠️ Requires Ozow activation first!
  //           Email support@ozow.com with your site code
  //           Subject: Enable PayShap Request — [SITE CODE]
  Future<void> _launchOzow(OzowPaymentMethod method) async {
    setState(() {
      _loading = true;
      _lastResult = null;
    });

    final result = await OzowPaymentPlugin.startPayment(
      context: context,
      config: OzowConfig(
        siteCode: 'YOUR_SITE_CODE', // ← Step 1: replace
        privateKey: 'YOUR_PRIVATE_KEY', // ← Step 1: replace
        apiKey: 'YOUR_API_KEY', // ← Step 1: replace
        amount: 10.00, // ← Step 2: replace with dynamic amount
        transactionReference: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
        bankReference: 'My Ozow Shop', // ← Step 3: replace with your store name
        // ── Step 7: Redirect URLs ──────────────────────
        // Replace with URLs from your Ozow Dashboard.
        // Must match Sites → URL settings exactly.
        cancelUrl: 'https://pay.ozow.com/cancel',
        errorUrl: 'https://pay.ozow.com/error',
        successUrl: 'https://pay.ozow.com/success',

        isTest: false, // ← Step 6: true for testing
        // ── Step 8: PayShap standalone button ─────────
        // Card    → selectedBankId = null
        //           Opens full Ozow payment page
        // PayShap → selectedBankId = OzowBankIds.payShap
        //           Goes directly to PayShap bank selection
        //           ⚠️ Requires Ozow activation first!
        //           Email support@ozow.com to activate.
        selectedBankId: method == OzowPaymentMethod.payshap
            ? OzowBankIds.payShap
            : null,

        // ── Optional: pre-populate customer phone ──────
        // Ozow pre-fills the cellphone number field on
        // the PayShap screen — speeds up the flow.
        // NOT included in hash check.
        // customerCellphoneNumber: '0821234567',
      ),
    );

    setState(() {
      _loading = false;
      _lastResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Order summary card ─────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Product', style: TextStyle(color: Colors.grey)),
                      Text(
                        'R 10.00', // ← matches amount above
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'R 10.00', // ← matches amount above
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1ABFA1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Pay button ─────────────────────────────
            // Tap → method selector (Card or PayShap)
            // Select → Ozow payment sheet launches
            _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1ABFA1)),
                  )
                : OzowButton(onPressed: _pay),

            // ── Result — Step 4: handle result here ────
            if (_lastResult != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lastResult!.isSuccess
                      ? Colors.green.shade50
                      : _lastResult!.isCancelled
                      ? Colors.orange.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _lastResult!.isSuccess
                        ? Colors.green.shade200
                        : _lastResult!.isCancelled
                        ? Colors.orange.shade200
                        : Colors.red.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _lastResult!.isSuccess
                          ? Icons.check_circle
                          : _lastResult!.isCancelled
                          ? Icons.cancel_outlined
                          : Icons.error_outline,
                      color: _lastResult!.isSuccess
                          ? Colors.green
                          : _lastResult!.isCancelled
                          ? Colors.orange
                          : Colors.red,
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastResult!.isSuccess
                          ? '✅ Payment Successful!'
                          : _lastResult!.isCancelled
                          ? '⚠️ Payment Cancelled'
                          : '❌ Payment Failed',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (_lastResult!.transactionId != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'TxID: ${_lastResult!.transactionId}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                    if (_lastResult!.errorMessage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _lastResult!.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
