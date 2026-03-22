## 0.0.1

* TODO: Describe initial release.
# Changelog

All notable changes to the `ozow_payment_plugin` package will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---



## [1.0.0] - 2026-03-20

### 🎉 Initial Release

#### Added
- `OzowPaymentPlugin.startPayment()` — launch Ozow's secure hosted payment sheet with a single method call
- `OzowConfig` — merchant configuration model supporting:
    - Site code, private key and API key
    - Dynamic amount (cart total, wallet top-up, subscription price, etc.)
    - Unique transaction reference per payment
    - Bank reference shown on customer's bank statement
    - Optional webhook notify URL
    - Optional success, cancel and error URL overrides
    - Test/sandbox mode toggle
- `OzowResult` — payment result model with:
    - `isSuccess`, `isCancelled`, `isError`, `isPending` status flags
    - `transactionId` — Ozow transaction reference
    - `reference` — your transaction reference
    - `errorMessage` — error description if payment failed
    - `rawParams` — full raw response from Ozow
- `OzowButton` — branded payment button widget supporting:
    - Standard Ozow button
    - Absa Pay button
    - Capitec Pay button
    - Nedbank Direct EFT button
    - Loading state
- `OzowCardValidator` — client-side card validation:
    - Luhn algorithm for card number validation
    - Expiry date validation with 2-digit and 4-digit year support
    - CVV validation with Amex (4-digit) support
    - Cardholder name validation
    - Card type detection — Visa, Mastercard, Amex, Discover
    - `isAllValid()` — validate all fields at once
- `OzowPaymentSheet` — full-screen WebView payment sheet with:
    - Animated Ozow loading screen
    - Automatic success/cancel/error URL detection
    - Retry on error support
    - Close button with cancelled result callback
- `OzowLoadingScreen` — animated loading screen with:
    - Pulsing Ozow logo rings
    - TLS encryption security badge
    - Light and dark mode support
- `OzowResultScreen` — animated payment result screen with:
    - Success, cancelled, error and pending states
    - Animated scale entrance
    - Transaction ID display
    - Retry button on error
    - Light and dark mode support
- `OzowPaymentMethodSelector` — payment method selection screen with:
    - Card, Pay by Bank, PayShap and Voucher options
    - Dynamic amount header
    - Step progress indicator
    - Mastercard and Visa logo display
    - T&Cs and TLS footer
    - Light and dark mode support
- `OzowHashService` — SHA512 hash generation and verification for tamper-proof payment requests
- `OzowUrlBuilder` — Ozow payment URL builder with correct parameter ordering

#### Platform Support
- ✅ Android (API 21+)
- ✅ iOS (12.0+) - ⚠️ Configured — awaiting Mac test environment
- ✅ Web

#### Dependencies
- `webview_flutter: ^4.13.1`
- `webview_flutter_android: ^4.10.13`
- `webview_flutter_wkwebview: ^3.24.1`
- `crypto: ^3.0.7`
- `plugin_platform_interface: ^2.1.8`

---

## [Unreleased]

### Planned
- PayShap deep link support
- Saved payment methods
- Transaction history widget
- Additional bank branded buttons (FNB, Standard Bank, Discovery Bank)
- Biometric payment confirmation
- Receipt generation

---
## [1.0.1] - 2026-03-22

### Fixed
- Updated README with full documentation
- Added GitHub repository links to pubspec.yaml


*For upgrade instructions and migration guides, see the
[README](README.md).*