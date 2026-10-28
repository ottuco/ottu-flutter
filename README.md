# ottu_flutter

Ottu Flutter SDK containing repo

## Downloading the Plugin

1. In the merchant application go to the `pubspec.yaml` file and find the dependencies: tag.
2. Below that tag add dependency tag with `ottu_flutter_checkout:` name.
3. Below that dependency name add git dependency to the Flutter Ottu SDK with this url: `https://github.com/ottuco/ottu-flutter.git`
4. Run `flutter pub get` command

## Sample

Please add the section below to your `pubspec.yaml` file
```
dependencies:
    flutter:
    sdk: flutter

    ottu_flutter_checkout:
    #to use ottu_flutter_checkout sdk from the local source uncomment line below and comment 3 lines with git specification
    #path: ../ottu_flutter_checkout
    git:
        url: https://github.com/ottuco/ottu-flutter.git
        ref: main
```

For source samples please refer to `Sample` folder.

### iOS Sample App

In order to install the Flutter iOS plugin and run the demo app, it is required to perform the following initial steps:
1. Open `ottu-flutter/Sample` in the terminal.
2. Run `flutter config --enable-swift-package-manager` command.
3. Run `flutter run` command, which actually compiles the app and opens it in the Xcode.

Please note, it is needed only for the very first launch, in order to install all needed Swift packages.
Per each next launch, the iOS app is simply opened in Xcode.

## Implementation

Import `package:ottu_flutter_checkout/ottu_flutter_checkout.dart`, create
`CheckoutArguments` for your session, and add `OttuCheckoutWidget` to your screen.
The widget manages native checkout height and platform channels internally.
Pass payment and verification callbacks directly to `OttuCheckoutWidget`.

```dart
OttuCheckoutWidget(
  arguments: checkoutArguments,
  verifyPayment: verifyPayment,
  successCallback: onSuccess,
  errorCallback: onError,
  cancelCallback: onCancel,
)
```

The callback names above refer to your application's existing handlers. See
[the sample checkout screen](Sample/lib/feature/checkout/checkout_screen.dart)
for an implementation.

## Checkout arguments initialisation
Below you may find sample of ```CheckoutArguments``` initialisation that requires  ```OttuCheckoutWidget```. 
You may find this sample in the ```home_screen_cubit.dart``` at ```onPay``` method.

```dart
    final checkoutArguments = CheckoutArguments(
        merchantId: state.merchantId,
        apiKey: state.apiKey,
        sessionId: state.sessionId ?? "",
        amount: amount,
        showPaymentDetails: state.showPaymentDetails,
        paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings(
          mode: PaymentOptionsDisplayMode.LIST,
          visibleItemsCount: 5,
        ),
        setupPreload: state.preloadPayload == true ? _apiTransactionDetails : null,
        formsOfPayment: formOfPayments?.isNotEmpty == true ? formOfPayments : null,
        theme: _theme);
```

## Callbacks
Please note that the callbacks are native (Android/iOS). They can be found in the following files:
* Android: `https://github.com/ottuco/ottu-flutter/blob/main/android/src/main/kotlin/com/ottu/flutter/checkout/CheckoutView.kt`
* iOS: `https://github.com/ottuco/ottu-flutter/blob/main/ios/ottu_flutter_checkout/Sources/ottu_flutter_checkout/CheckoutPlatformView.swift`

## Separate Pay button (Android and iOS)

`CheckoutArguments.isSplitPayButton` controls where the native Pay button is
shown. The default, `false`, keeps it inside checkout. With `true`, the merchant
keeps `OttuCheckoutWidget` for checkout content and places `PayButtonWidget`
wherever it is needed on the same screen, including a fixed bottom footer.

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    OttuCheckoutWidget(arguments: arguments), // isSplitPayButton: true
    const Text('Merchant content'),
    const PayButtonWidget(),
  ],
)
```

The native SDK controls the button's appearance, visibility, enabled state, and
payment action. Height updates are automatic on Android and iOS. Keep payment
and verification callbacks on `OttuCheckoutWidget`.

See the [separate Pay button guide](docs/split-pay-button.md) for argument setup,
inline and fixed-bottom examples, platform requirements, and branch changes.
