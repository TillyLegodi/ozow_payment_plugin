# 💳 Ozow Flutter SDK

The easiest way to accept payments in South Africa using Flutter.

🚀 3 lines to get started  
🔐 Production-ready architecture  
🔥 Firebase integration included  

[Get Started](#quick-start) • [Documentation](#firebase-integration) • [Example App](./example)

---

## 🎥 Demo (Coming Soon)

Add GIF here



# ozow_payment_plugin

[![pub.dev](https://img.shields.io/pub/v/ozow_payment_plugin.svg)](https://pub.dev/packages/ozow_payment_plugin)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue.svg)
![Production Ready](https://img.shields.io/badge/Production-Ready-success)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A **production-ready Flutter SDK for the Ozow payment gateway**, built for African developers.

Accept **Card, Pay by Bank, PayShap, and Voucher payments** with minimal setup, secure backend support, and Firebase-ready architecture.

⚡ Built for startups, fintech apps, marketplaces, and ride-hailing platforms.

---

## ✨ Features

* ✅ **3 lines of code** to start accepting payments
* ✅ **Secure WebView checkout** (Ozow hosted page)
* ✅ **All payment methods** — Card, Pay by Bank, PayShap, Vouchers
* ✅ **SHA512 signing support**
* ✅ **Result callbacks** — success, cancelled, error, pending
* ✅ **Bank-branded UI buttons**
* ✅ **PCI compliant** — no card data handled by your app
* ✅ **Firebase-ready architecture**
* ✅ Android, iOS & Web support

---

## 🚀 Quick Start (Testing Only)

```dart
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
```

⚠️ **This method is for testing only — do NOT use in production**

---

## 🔐 Production Integration (Recommended)

In production:

* Private keys stay on your backend
* Hash is generated securely
* Flutter app never exposes secrets

```dart
final paymentData = await MyBackend.createPayment();

final result = await OzowPaymentPlugin.startPayment(
  context: context,
  config: OzowConfig(
    siteCode: paymentData.siteCode,
    privateKey: '',
    apiKey: paymentData.apiKey,
    amount: paymentData.amount,
    transactionReference: paymentData.reference,
    bankReference: 'My Store',
    hashCheck: paymentData.hash,
  ),
);
```

---

## 🏗️ Architecture (Production)

Flutter App
⬇
Firebase Cloud Function / Backend
⬇
Secret Manager / Environment Variables
⬇
Ozow API

---

## 🔥 Firebase Integration

### Remote Config (Safe Usage)

Use Remote Config for:

* Payment enable/disable
* Payment method toggles
* Test vs live mode
* UI configurations

```dart
final isTest = remoteConfig.getBool('ozow_is_test');
```

### ⚠️ Do NOT store secrets in Remote Config

Remote Config values are accessible by the app.

---

### Cloud Functions (Secure Hash Generation)

```javascript
exports.createOzowPayment = async (req, res) => {
  const hash = generateSHA512Hash({
    siteCode: process.env.OZOW_SITE_CODE,
    privateKey: process.env.OZOW_PRIVATE_KEY,
    amount: req.body.amount,
    reference: req.body.reference,
  });

  res.json({
    siteCode: process.env.OZOW_SITE_CODE,
    apiKey: process.env.OZOW_API_KEY,
    amount: req.body.amount,
    reference: req.body.reference,
    hash,
  });
};
```

---

## 📦 Result Handling

```dart
if (result.isSuccess) {
  // Payment successful
} else if (result.isCancelled) {
  // User cancelled
} else if (result.isError) {
  // Payment failed
} else if (result.isPending) {
  // Processing
}
```

---

## 🎯 Use Cases

* Ride-hailing apps (Uber-style platforms)
* E-commerce apps
* Wallet systems
* Subscription platforms
* Fintech & SaaS products

---

## 🏦 Supported Payments

* 💳 Card (Visa / Mastercard with 3DS)
* 🏦 Pay by Bank (EFT)
* ⚡ PayShap
* 🎫 Vouchers

---

## 🔐 Security

* Hosted checkout (Ozow)
* No card data handled in-app
* SHA512 request signing
* TLS encryption
* Backend-secured secrets

---

## ⚠️ Important

Never store your **Ozow private key** in your Flutter app.

---

## 🤝 Contributing

Pull requests are welcome.

---

## 📞 Support

* GitHub Issues
* Ozow Support

---

Built with ❤️ by Tilly Legodi for the African Flutter community 🇿🇦

