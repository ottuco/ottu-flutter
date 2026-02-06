# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ottu-flutter-checkout** is a Flutter plugin that wraps native Ottu payment checkout SDKs for Android and iOS using Platform Views. The Dart layer is a thin bridge — all payment processing, card input, and CHD handling happens exclusively in the native SDKs:

- **Android**: `com.github.ottuco:ottu-android-checkout:2.1.7` (JitPack)
- **iOS**: `ottu_checkout_sdk` from `https://github.com/ottuco/ottu-ios` (from 2.1.10, SPM)

The plugin is private (`publish_to: 'none'`), consumed via git dependency by merchant apps.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Generate JSON serialization code (.g.dart files)
dart run build_runner build --delete-conflicting-outputs

# Static analysis
flutter analyze
```

### Sample App (from Sample/ directory)

```bash
cd Sample && flutter pub get
flutter run --dart-define=MERCHANT_ID=<id> --dart-define=API_KEY=<key>
```

iOS first-time setup requires `flutter config --enable-swift-package-manager` before the first `flutter run`.

### Local Android SDK Development

To substitute the JitPack dependency with a local `ottu-android-checkout` checkout, add to `android/local.properties`:
```
ottuSdk=/path/to/local/ottu-android-checkout
```
`settings.gradle.kts` auto-substitutes via Gradle composite builds.

## Architecture

### Plugin Communication

```
Dart (OttuCheckoutWidget)
  → Serializes CheckoutArguments to JSON string
  → Passes as creationParams to AndroidView / UiKitView
  → Native deserializes, initializes native Checkout SDK
  → MethodChannel "com.ottu.sample/checkout" for callbacks:
      Native→Dart: METHOD_CHECKOUT_HEIGHT, METHOD_PAYMENT_SUCCESS_RESULT,
                   METHOD_PAYMENT_ERROR_RESULT, METHOD_PAYMENT_CANCEL_RESULT
      Dart→Native: METHOD_ON_WIDGET_DETACHED
```

The Dart layer does NOT register `setMethodCallHandler` — payment result callbacks are handled by the host app (see Sample's `chackout_screen.dart`).

### Public API Surface (`lib/ottu_flutter_checkout.dart`)

- `OttuCheckoutWidget` — main widget, creates native platform view
- `CheckoutArguments` — required config (merchantId, apiKey, sessionId, amount, etc.)
- `CheckoutTheme` + sub-types — comprehensive theming model
- `FormsOfPayment` — enum (redirect, flex, stcPay, tokenPay, cardOnSite, googlePay, applePay)
- `PaymentOptionsDisplaySettings` / `PaymentOptionsDisplayMode` — display config

### Code Generation

Model classes use `json_serializable`. After modifying any `@JsonSerializable` class, regenerate:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Generated `*.g.dart` files are committed to the repo.

### Sample App Architecture

BLoC (Cubits) + GetIt DI + GoRouter + Dio. Each feature defines a `Module` with `init(GetIt)` and `router()`.

## Platform Requirements

- **Dart SDK**: ^3.6.0
- **Android**: minSdk 26, compileSdk 36, Kotlin 2.2.20, AGP 8.9.3
- **iOS**: iOS 15+, Swift tools 5.5
- **Localization**: English and Arabic (Kuwait) for error messages on both platforms

## Known Code Issues

- Channel name `com.ottu.sample/checkout` contains "sample" — inherited from demo, not renamed
- File `extention.dart` misspelled (should be "extension"); Sample has `chackout_screen.dart` (should be "checkout")
- `logger` dependency declared in pubspec.yaml but unused in the Dart SDK layer
- `collection` imported in `checkout_theme.dart` but not declared as explicit dependency
- No test directory exists anywhere — zero test coverage

---

# Ottu Flutter SDK (Wrapper over iOS + Android) — Code Review Rules (Claude Code Agent)

## Mission

Review the Flutter layer as a SECURITY-CRITICAL WRAPPER around the native PCI-scoped iOS/Android SDKs.
Be ruthless and practical: find leakage paths, unsafe platform-channel patterns, missing tests, and packaging risks.
NO essays. Every finding must reference concrete code locations.

## Hard Constraints

- Flutter wrapper must never become a CHD handling layer.
- Flutter must not log, store, or forward CHD. All CHD capture/processing must remain inside native SDKs.
- Assume hostile merchant apps and hostile runtime: debug tooling, other packages, method-channel interception attempts, overlays, rooted/jailbroken devices.

## Non-Negotiable Blockers (fail the review if present)

1) **CHD exposure in Flutter:**
   Any PAN/expiry/CVV/track data can appear in Dart objects, method channel payloads, logs, exceptions, UI widgets, analytics, crash reports, or is stored on disk.

2) **Secrets in Flutter package:**
   Static API keys, long-lived tokens, credentials, private keys, or "hidden" secrets in assets, constants, build configs, examples.

3) **Channel insecurity:**
   MethodChannel/EventChannel passes sensitive data, uses dynamic/untyped maps without schema validation, or allows arbitrary method invocation without strict allowlisting.

4) **Storage of sensitive data:**
   Using shared_preferences, hive, sqlite, files, cache for tokens/PII without strict justification + encryption + expiry; CHD is NEVER allowed.

5) **Network in Flutter layer for payment-critical flows:**
   Flutter performing direct payment API calls that should be done in native PCI layers, especially if request bodies could contain sensitive fields.

## Review Scope (you must cover all)

### A) Boundary Proof: "Wrapper Only"

- Identify ALL Flutter surfaces that could touch sensitive data:
  - Dart models, form widgets, callbacks, exceptions, logs, analytics hooks.
- Prove that:
  - Flutter never accepts raw card input (no PAN/CVV entry fields in Dart).
  - Flutter never receives CHD from native via channels.
  - Flutter callbacks return only safe outputs (status, masked values, non-sensitive ids).

**Known state of this codebase:**
- No PAN/CVV/expiry fields exist in any Dart model or widget — PASS
- No card input widgets in Dart — PASS
- Native callbacks use `.toString()` / `.description` on opaque SDK objects before sending to Dart — RISK: if native SDK includes sensitive fields in toString, they leak across the channel (`CheckoutView.kt:185,189,194`, `CheckoutPlatformView.swift:348,365,382`)

### B) Platform Channels (MethodChannel/EventChannel/Pigeon/FFI)

- Inventory every channel:
  - channel name, methods, argument shapes, return shapes, event payloads.
- Enforce strictness:
  - Allowlist methods (no "callNative(String methodName)" patterns).
  - Strong schemas: prefer Pigeon or typed wrappers; avoid dynamic `Map<String, dynamic>` for sensitive flows.
  - Validate required keys + types + enums; reject unknown keys.
  - Errors: sanitize PlatformException messages; never include payload dumps.
  - Ensure no "debug passthrough" methods that expose native internals.

**Known state of this codebase:**
- Single channel `com.ottu.sample/checkout` — no wildcard handlers, no debug passthrough
- Android side has NO `setMethodCallHandler` (never receives Dart calls)
- iOS side handles only `METHOD_ON_WIDGET_DETACHED` in its handler
- All data crosses boundary as JSON string in creationParams via `Map<String, dynamic>` — double-serialized
- `apiKey` is in the creationParams payload (`checkout_arguments.dart:11`, `checkout_widget.dart:33-35`)
- No error handling on channel calls — unhandled `PlatformException` would propagate with full context including apiKey (`checkout_widget.dart:27,33-34`)

### C) Flutter Logging / Error Handling

- Find all logs: print/debugPrint, logger packages, FlutterError.onError, Zone error handlers.
- Enforce:
  - No logging of channel args, request/response bodies, headers.
  - Central redaction utilities for any identifiers/tokens; test them.
  - Example app must not teach insecure logging patterns.

**Known state of this codebase:**
- SDK: `print("OttuCheckoutWidget.dispose()")` in `checkout_widget.dart:26` — not CHD but sets bad pattern
- Android: 27 `Log.*` calls with NO debug/release guard; callbacks logged at all levels (`CheckoutView.kt:184,188,192,202`); SDK logger set to INFO (`CheckoutView.kt:162`)
- iOS: `debugPrint(error)` at `CheckoutPlatformView.swift:179` could log API key in init errors
- Sample app: `LogInterceptor(responseBody: true, requestBody: true)` always active (`ottu_api_impl.dart:15`); API key explicitly logged (`home_screen_cubit.dart:96`); error handler dumps headers via `print()` (`ottu_api_impl.dart:48-54`)

### D) Persistence / Caching in Flutter

- Find all storage usage: shared_preferences, hive, secure_storage, files, temp, cache managers.
- CHD is forbidden on disk, always.

**Known state of this codebase:**
- No storage of any kind in the SDK or Sample app — PASS

### E) UI & UX: Prevent Accidental Exposure

- Ensure wrapper does not render sensitive values in Flutter widgets.
- Lifecycle: ensure wrapper forwards "secure screen" needs to native layer.

**Known state of this codebase:**
- SDK renders only native views (AndroidView/UiKitView) — no sensitive Flutter widgets
- Sample app shows apiKey in plaintext TextFormField without `obscureText` (`home_screen.dart:117-125`)
- No screenshot/app-switcher protection forwarded from wrapper to native

### F) Networking in Flutter Wrapper

- Inventory any HTTP clients (dio/http).
- Flutter wrapper should not transmit CHD or payment payloads.

**Known state of this codebase:**
- SDK: zero networking — PASS
- Sample app: Dio client for session creation with `Authorization: Api-Key` header; `android:usesCleartextTraffic="true"` in Sample manifest (`AndroidManifest.xml:14`)

### G) Package / Supply Chain Hygiene

- Dependency review: list critical packages, flag outdated/high-risk, check transitive surprises.
- Release artifacts: no debug flags, no dev endpoints, consistent lockfiles.

**Known state of this codebase:**
- Android SDK from JitPack (no artifact signing — lower trust than Maven Central)
- Android: `isMinifyEnabled = false` in release build — no obfuscation (`build.gradle.kts:55-56`)
- ProGuard `-keep class com.ottu.** { *; }` keeps everything even if minification were enabled
- iOS PrivacyInfo.xcprivacy declares zero data collection/API usage — likely App Store rejection risk
- `pubspec.lock` is gitignored (not committed)

### H) Example App / Documentation Risks

- Must not include real keys, secrets, or unsafe patterns.
- Must not show capturing PAN/CVV in Flutter.
- Must not instruct merchants to enable insecure settings.

**Known state of this codebase:**
- No real secrets in git (placeholder defaults only)
- No PAN/CVV capture in Flutter — PASS
- UNSAFE PATTERNS TAUGHT: unconditional `LogInterceptor`, `usesCleartextTraffic="true"`, debug signing for release, API key logging, raw payment result display in AlertDialogs

### I) Testing Requirements (must be enforced)

Assess test coverage and add/describe missing tests:

- **Unit tests (Dart):**
  - Schema validation for channel messages (reject unknown keys/types)
  - Redaction/sanitization utilities
  - API surface: ensure callbacks cannot carry CHD-shaped fields

- **Integration tests:**
  - Verify method channel calls don't include sensitive keys (PAN/CVV/expiry) by asserting payload key sets
  - Ensure errors are sanitized (no payload echo)

- **Static checks:**
  - Lint rules forbidding print/debugPrint in lib/ (or in sensitive namespaces)
  - CI checks to scan for PAN-like patterns and "cvv" fields in Dart code/tests/assets

**Known state of this codebase:**
- ZERO tests exist — no test/ directory, no test dependencies, no CI pipeline
- No lint rules against print/debugPrint
- No static scanning for sensitive patterns
