# 💳 Ozow Flutter SDK

The easiest way to accept payments in South Africa using Flutter.

🚀 3 lines to get started
🔐 Production-ready architecture
🔥 Firebase integration included

[Get Started](#-quick-start-testing-only) • [Production Setup](#-production-backend-setup-firebase) • [Example App](./example)

---

## 🎥 Demo

Watch the plugin in action:

👉 https://youtube.com/shorts/H1KOdCjFCEk?feature=share

This demo shows:

* Payment flow
* Ozow checkout UI
* Result handling (success / cancel / error)

---

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

# 🔐 Production Backend Setup (Firebase)

Follow these steps to securely integrate Ozow in production.

---

## 1️⃣ Install Node.js

Download and install Node.js (LTS).

Verify:

```bash
node -v
npm -v
```

---

## 2️⃣ Install Firebase CLI

```bash
npm install -g firebase-tools
firebase --version
```

---

## 3️⃣ Login to Firebase

```bash
firebase login
```

---

## 4️⃣ Initialize Firebase Functions

From your project root:

```bash
firebase init functions
```

Select:

* JavaScript
* Your Firebase project
* Install dependencies

---

## 5️⃣ Add your Cloud Function

Inside `functions/index.js`:

```javascript
const functions = require("firebase-functions");
const crypto = require("crypto");

exports.createOzowPayment = functions.https.onRequest((req, res) => {
  const { amount, reference } = req.body;

  const siteCode = process.env.OZOW_SITE_CODE;
  const privateKey = process.env.OZOW_PRIVATE_KEY;

  const data = `${siteCode}${reference}${amount}${privateKey}`;

  const hash = crypto
    .createHash("sha512")
    .update(data)
    .digest("hex");

  res.json({
    siteCode,
    apiKey: process.env.OZOW_API_KEY,
    amount,
    reference,
    hash,
    bankReference: "My Store",
    isTest: true
  });
});
```

---

## 6️⃣ Install dependencies

```bash
cd functions
npm install firebase-admin firebase-functions
```

---

## 7️⃣ Add environment variables

Create `functions/.env`:

```env
OZOW_SITE_CODE=YOUR_SITE_CODE
OZOW_API_KEY=YOUR_API_KEY
OZOW_PRIVATE_KEY=YOUR_PRIVATE_KEY
```

---

## 8️⃣ Protect your secrets

Add to `.gitignore`:

```gitignore
functions/.env
```

---

## 9️⃣ Deploy your functions

From project root:

```bash
firebase deploy --only functions
```

---

## 🔟 Use your backend URL

After deployment, Firebase will give you:

```text
https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/createOzowPayment
```

Use this in your Flutter app.

---

## 🧪 Optional: Test before deploy

```bash
cd functions
node -e "require('./index.js'); console.log('OK')"
```

---

## ⚠️ Common Errors

**npm not recognized**
→ Install Node.js and restart terminal

**404 from backend**
→ Check your function URL is correct

**Cannot find module**
→ Check folder structure and file names

---

## 🔥 Firebase Integration

### Remote Config (Safe Usage)

Use Remote Config for:

* Feature toggles
* Payment enable/disable
* Test vs live mode

```dart
final isTest = remoteConfig.getBool('ozow_is_test');
```

---

### ⚠️ Never store secrets in Remote Config

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

* Ride-hailing apps
* E-commerce platforms
* Wallet systems
* Subscription apps
* Fintech products

---

## 🏦 Supported Payments

* 💳 Card (Visa / Mastercard)
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
