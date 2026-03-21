# ozow_payment_plugin

[![pub.dev](https://img.shields.io/pub/v/ozow_payment_plugin.svg)](https://pub.dev/packages/ozow_payment_plugin)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue.svg)](https://flutter.dev)

A Flutter plugin for the **Ozow payment gateway** — the easiest way to accept payments in South Africa.

Supports **Card**, **Pay by Bank**, **PayShap**, and **Voucher** payments via Ozow's secure hosted payment page.

---

## 📱 Preview

| Checkout | Ozow Payment Sheet | Success |
|---|---|---|
| ![Checkout](https://your-screenshot-url/checkout.png) | ![Payment](https://your-screenshot-url/payment.png) | ![Success](https://your-screenshot-url/success.png) |

---

## ✨ Features

- ✅ **3 lines of code** to accept payments
- ✅ **Secure WebView** — Ozow's hosted payment page
- ✅ **SHA512 hash signing** — tamper-proof requests
- ✅ **All Ozow payment methods** — Card, Pay by Bank, PayShap, Vouchers
- ✅ **Bank branded buttons** — Absa Pay, Capitec Pay, Nedbank Direct EFT
- ✅ **Card validation** — Luhn algorithm + expiry + CVV checks
- ✅ **Result callbacks** — success, cancelled, error, pending
- ✅ **Android, iOS and Web** support
- ✅ **Light and dark mode** support
- ✅ **PCI compliant** — no raw card data handled by your app
- ✅ **No extra dependencies** needed by your users

---

## 🚀 Getting Started

### 1. Add to your `pubspec.yaml`
```yaml
dependencies:
  ozow_payment_plugin: ^1.0.0
```

### 2. Run pub get
```bash
flutter pub get
```

### 3. Android — add internet permission

In `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 4. That's it! No other setup required.

---

## 📦 Usage

### Basic — 3 lines of code
```dart
import 'package:ozow_payment_plugin/ozow_payment_plugin.dart';

final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(
    siteCode: 'YOUR_SITE_CODE',
    privateKey: 'YOUR_PRIVATE_KEY',
    apiKey: 'YOUR_API_KEY',
    amount: 150.00,
    transactionReference: 'ORDER-001',
    bankReference: 'My Store',
  ),
);

if (result.isSuccess) {
  print('Payment successful! TxID: ${result.transactionId}');
}
```
## 🔐 Security Best Practices

### ⚠️ Never hardcode your Private Key in Flutter

Your Ozow `privateKey` should **never** be stored in your Flutter app.
Anyone can decompile an APK and extract it.

### ✅ Recommended — Backend hash generation

Generate the hash on your server and pass it to the plugin:
```dart
// 1. Call your backend to get a signed payment URL
final paymentData = await MyBackendService.createOzowPayment(
  amount: cart.total,
  reference: 'ORDER-${order.id}',
);

// 2. Pass the pre-computed hash — privateKey stays on your server
final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(
    siteCode: paymentData.siteCode,
    privateKey: '',              // ← empty, hash already computed
    apiKey: paymentData.apiKey,
    amount: paymentData.amount,
    transactionReference: paymentData.reference,
    bankReference: 'My Store',
    hashCheck: paymentData.hash, // ← pre-computed from your server
  ),
);
```

### Your backend endpoint (Node.js example)
```javascript
app.post('/api/ozow/create-payment', async (req, res) => {
  const { amount, reference } = req.body;
  
  const hash = generateSHA512Hash({
    siteCode: process.env.OZOW_SITE_CODE,
    privateKey: process.env.OZOW_PRIVATE_KEY, // ← safe on server
    amount,
    reference,
  });
  
  res.json({
    siteCode: process.env.OZOW_SITE_CODE,
    apiKey: process.env.OZOW_API_KEY,
    amount,
    reference,
    hash,
  });
});
```

### Security summary

| | Hardcoded in app | Backend generated |
|---|---|---|
| Private key exposed | ❌ Yes | ✅ No |
| Google Play safe | ❌ No | ✅ Yes |
| Apple App Store safe | ❌ No | ✅ Yes |
| Recommended | ❌ | ✅ |




---

### Handle all result states
```dart
final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(...),
);

if (result.isSuccess) {
  // ✅ Payment completed
  print('TxID: ${result.transactionId}');
  navigateToSuccessScreen();

} else if (result.isCancelled) {
  // ⚠️ User closed the payment sheet
  showCancelledMessage();

} else if (result.isError) {
  // ❌ Payment failed
  print('Error: ${result.errorMessage}');
  showErrorMessage();

} else if (result.isPending) {
  // ⏳ Payment is processing
  showPendingMessage();
}
```

---

### E-commerce cart
```dart
// Amount comes from your cart total
final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(
    siteCode: 'YOUR_SITE_CODE',
    privateKey: 'YOUR_PRIVATE_KEY',
    apiKey: 'YOUR_API_KEY',
    amount: cart.totalAmount,                        // ← dynamic cart total
    transactionReference: 'ORDER-${order.id}',       // ← unique per order
    bankReference: 'My Store',
    notifyUrl: 'https://mystore.com/api/ozow/notify', // ← optional webhook
  ),
);
```

---

### Wallet top-up
```dart
final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(
    siteCode: 'YOUR_SITE_CODE',
    privateKey: 'YOUR_PRIVATE_KEY',
    apiKey: 'YOUR_API_KEY',
    amount: topUpAmount,                              // ← user entered amount
    transactionReference: 'WALLET-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
    bankReference: 'Wallet Top-Up',
  ),
);
```

---

### Subscription payment
```dart
final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(
    siteCode: 'YOUR_SITE_CODE',
    privateKey: 'YOUR_PRIVATE_KEY',
    apiKey: 'YOUR_API_KEY',
    amount: plan.monthlyPrice,                        // ← plan price
    transactionReference: 'SUB-${user.id}-${plan.id}',
    bankReference: 'Monthly Subscription',
  ),
);
```

---

### Branded bank buttons
```dart
// Standard Ozow button
OzowButton(onPressed: _pay)

// Absa Pay button
OzowButton(
  onPressed: _pay,
  style: OzowButtonStyle.absaPay,
)

// Capitec Pay button
OzowButton(
  onPressed: _pay,
  style: OzowButtonStyle.capitecPay,
)

// Nedbank Direct EFT button
OzowButton(
  onPressed: _pay,
  style: OzowButtonStyle.nedbankEFT,
)
```

---

### Card validation (optional — before launching payment)
```dart
import 'package:ozow_payment_plugin/ozow_payment_plugin.dart';

// Validate a single field
final cardResult = OzowCardValidator.validateCardNumber('4111111111111111');
if (!cardResult.isValid) {
  print(cardResult.errorMessage); // 'Invalid card number'
}

// Validate all fields at once
final isValid = OzowCardValidator.isAllValid(
  cardNumber: '4111111111111111',
  expiryMonth: '12',
  expiryYear: '2026',
  cvv: '123',
  cardholderName: 'John Doe',
);

// Detect card type
final cardType = OzowCardValidator.detectCardType('4111111111111111');
print(cardType); // 'visa'
```

---

## ⚙️ OzowConfig Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `siteCode` | `String` | ✅ | Your Ozow site code |
| `privateKey` | `String` | ✅ | Your Ozow private key |
| `apiKey` | `String` | ✅ | Your Ozow API key |
| `amount` | `double` | ✅ | Amount to charge (e.g. `150.00`) |
| `transactionReference` | `String` | ✅ | Unique reference per payment |
| `bankReference` | `String` | ✅ | Shown on customer's bank statement |
| `notifyUrl` | `String?` | ❌ | Webhook URL for server notification |
| `successUrl` | `String?` | ❌ | Override success redirect URL |
| `cancelUrl` | `String?` | ❌ | Override cancel redirect URL |
| `errorUrl` | `String?` | ❌ | Override error redirect URL |
| `isTest` | `bool` | ❌ | `false` by default. Set `true` for testing |

---

## 📊 OzowResult Properties

| Property | Type | Description |
|---|---|---|
| `status` | `OzowPaymentStatus` | `success`, `cancelled`, `error`, `pending` |
| `isSuccess` | `bool` | `true` if payment completed |
| `isCancelled` | `bool` | `true` if user cancelled |
| `isError` | `bool` | `true` if payment failed |
| `isPending` | `bool` | `true` if payment is processing |
| `transactionId` | `String?` | Ozow transaction ID |
| `reference` | `String?` | Your transaction reference |
| `errorMessage` | `String?` | Error description if failed |
| `rawParams` | `Map?` | Full raw response from Ozow |

---

## 🔐 Security

- All payment processing happens on **Ozow's secure hosted page**
- Your app **never handles raw card data** — fully PCI compliant
- Every payment request is signed with a **SHA512 hash** using your private key
- Communication is protected with **TLS encryption**

---

## 🏦 Supported Payment Methods

| Method | Description |
|---|---|
| 💳 Card | Visa, Mastercard — with 3DS authentication |
| 🏦 Pay by Bank | Direct EFT via FNB, Standard Bank, Absa, Capitec, Nedbank and more |
| ⚡ PayShap | Instant payments via PayShap-enabled banks |
| 🎫 Voucher | 1Voucher and aCoin voucher redemption |

---

## 📱 Platform Support

| Platform | Supported |
|---|---|
| Android | ✅ |
| iOS | ✅ |⚠️ Configured — awaiting Mac test environment
| Web | ✅ |
| macOS | ❌ |
| Windows | ❌ |
| Linux | ❌ |

---

## 🔧 Requirements

| Requirement | Minimum version |
|---|---|
| Flutter | `>=3.3.0` |
| Dart | `>=3.0.0` |
| Android | API level 21+ |
| iOS | 12.0+ |

---

## 📝 Getting Ozow Credentials

1. Visit [ozow.com](https://ozow.com) and create a merchant account
2. Log in to your **Merchant Dashboard**
3. Navigate to **Sites** → select your site
4. Copy your **Site Code**, **Private Key** and **API Key**
5. Paste them into `OzowConfig`

> ⚠️ **Never commit your private key to version control.**
> Use environment variables or a secrets manager in production.

---

## 🧪 Testing

Set `isTest: true` in `OzowConfig` to use Ozow's sandbox environment:
```dart
config: OzowConfig(
  siteCode: 'YOUR_SITE_CODE',
  privateKey: 'YOUR_PRIVATE_KEY',
  apiKey: 'YOUR_API_KEY',
  amount: 10.00,
  transactionReference: 'TEST-001',
  bankReference: 'Test Store',
  isTest: true,   // ← sandbox mode
),
```

---

## 📄 License
```
MIT License — see LICENSE file for details.
```

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

---

## 📞 Support

- 📧 Plugin issues: Open a GitHub issue
- 🏦 Ozow API issues: [ozow.com/support](https://ozow.com/support)
- 📖 Ozow documentation: [docs.ozow.com](https://docs.ozow.com)

---

*Built with ❤️ by Tilly Legodi for the South African Flutter developer community 🇿🇦*