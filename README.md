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