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

### Android build requirements

Sample and the standalone plugin build use Android Gradle Plugin 9.3.3 and Gradle 9.5.0.
Merchant apps choose their own AGP and compatible Gradle versions. The plugin
supports AGP 8.x with the Kotlin Android plugin and AGP 9.x with built-in Kotlin.
It applies the Kotlin Android plugin only when built-in Kotlin is unavailable or disabled.
AGP 9.x hosts must provide Kotlin 2.3.20 on their build classpath, matching the
plugin's serialization compiler plugin. The plugin compiles against Android SDK 36;
Sample compiles and targets SDK 37. Older AGP 8.x releases may still be limited
by the minimum AGP and compile SDK requirements of AndroidX and Kotlin dependencies.

Use JDK 17 or later to run Gradle. Java and Kotlin bytecode still target Java 8.
The plugin requires Flutter 3.44 / Dart 3.12 or later. Sample requires
Flutter 3.47 / Dart 3.13 or later and enables built-in Kotlin. Sample retains
`android.newDsl=false` because the Flutter Gradle plugin still uses the legacy DSL.
Install Android SDK Platform 36 for the plugin and Platform 37 for Sample.

When `ottuSdk` points to a local native SDK composite build, that SDK must use
the same AGP version as the host app.

ARM64 debug APK builds were verified with Kotlin 2.3.20 in isolated hosts:

| AGP | Gradle | Kotlin support |
| --- | --- | --- |
| 8.12.3 | 8.14 | Kotlin Android plugin |
| 9.3.3 | 9.5.0 | Built-in Kotlin |

These checks used temporary copies of the local native SDK with matching AGP versions.

To build Sample with the local plugin:

```sh
cd Sample
flutter pub get
flutter build apk --debug
```

Android builds also create a named APK in `build/app/outputs/flutter-apk/`
and a named app bundle in `build/app/outputs/named-bundle/<variant>/` when building an AAB:

```sh
flutter build apk --release --dart-define-from-file=env.var.alpha.json
flutter build appbundle --release --dart-define-from-file=env.var.alpha.json
```

The filename is `<App name>_<flavour>_<environment>_<dd_MM_yyyy_mm:HH>.apk`
(or `.aab`). The app name is always `FlutterAndroid`, the flavour
uses the product flavor when configured and otherwise the build type, and the
environment uses `MERCHANT_ID` from the Dart defines. A missing `MERCHANT_ID`
leaves the environment segment empty. The timestamp uses local build time,
with minutes before hours, for example `FlutterAndroid_release__22_10_2026_05:14.apk`.
Split APK names append the ABI before `.apk`. Standard Flutter output files are
also retained for `flutter build` and `flutter run`.

### iOS Sample App

In order to install the Flutter iOS plugin and run the demo app, it is required to perform the following initial steps:
1. Open `ottu-flutter/Sample` in the terminal.
2. Run `flutter config --enable-swift-package-manager` command.
3. Run `flutter run` command, which actually compiles the app and opens it in the Xcode.

Please note, it is needed only for the very first launch, in order to install all needed Swift packages.
Per each next launch, the iOS app is simply opened in Xcode.

## Implementation

All steps those you will find bellow have already been implemented in the `Sample` app.

Here are steps to implement Ottu checkout widget from scratch:
1. You have successfully setup the plugin that mentioned above.
2. In your screen-widget override this method
    ```
    @override
    void didChangeDependencies()
   ```
3. Then in that method implement ```MethodChannel.setMethodCallHandler()``` with ```METHOD_CHECKOUT_HEIGHT``` method name.
   See ```chackout_screen.dart``` for instance in the `Sample` app.
4. Next, define ```ValueNotifier<int>``` property in a State class of a Widget. 
   It is essential to handle the height change of the native view.
5. Now, in the ```MethodCallHandler``` handle callback of a native method and assign ```int``` argument to the ```ValueNotifier```
6. This step is to add ```OttuCheckoutWidget```, so next decide a place on your screen where you want to show the checkout widget.
7. Wrap the ```OttuCheckoutWidget``` with ```SizedBox``` other container widget, is just for checkout view constraint.
8. After, wrap the ```SizedBox``` with ```ValueListenableBuilder<int>``` and pass ```int``` argument of the handler to the ```SizedBox``` as a height parameter.
9. Last, is to define arguments for ```OttuCheckoutWidget``` which described in the next chapter.

## Optional merchant widget

Pass `merchantWidgetRoute` to embed merchant Flutter content inside native checkout:

```dart
OttuCheckoutWidget(
  arguments: checkoutArguments,
  merchantWidgetRoute: '/merchantNestedWidget',
)
```

The host app must register the supplied route and return merchant content wrapped
in `NestedWrapperWidget`. The route runs in a separate Flutter engine with its own
Dart state. Omit `merchantWidgetRoute` or pass `null`/an empty string to create
checkout without a merchant widget or nested engine. A supplied route must exist;
route availability is not detected automatically. Configuration applies when the
native checkout view is created.

This replaces the previous `showMerchantWidget` SDK parameter. In the Sample app,
the **Show merchant widget** checkbox supplies `/merchantNestedWidget` when checked
and `null` when unchecked.

## Code sample

```dart
Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 46),
        Text(
          "Customer Application",
          textAlign: TextAlign.center,
          style: ts.TextStyle(fontSize: 24),
        ),
        //Start of Merchant content
        const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements")),
        //End of Merchant content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ValueListenableBuilder<int>(
            builder: (BuildContext context, int height, Widget? child) {
              return SizedBox(
                height: height.toDouble(),
                child: OttuCheckoutWidget(arguments: widget.checkoutArguments),
              );
            },
            valueListenable: _checkoutHeight,
          ),
        ),
        const SizedBox(height: 20),
        //Start of Merchant content
        const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements,"
                " Some users UI elements, Some users UI elements, Some users UI elements,"
                " Some users UI elements, Some users UI elements, Some users UI elements")),
        //End of Merchant content
      ])), // This trailing comma makes auto-formatting nicer for build methods.
    );
```

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
        apiTransactionDetails: state.preloadPayload == true ? _apiTransactionDetails : null,
        formsOfPayment: formOfPayments?.isNotEmpty == true ? formOfPayments : null,
        theme: _theme);
```

## Callbacks
Please note that the callbacks are native (Android/iOS). They can be found in the following files:
* Android: `https://github.com/ottuco/ottu-flutter/blob/main/android/src/main/kotlin/com/ottu/flutter/checkout/CheckoutView.kt`
* iOS: `https://github.com/ottuco/ottu-flutter/blob/main/ios/ottu_flutter_checkout/Sources/ottu_flutter_checkout/CheckoutPlatformView.swift`
