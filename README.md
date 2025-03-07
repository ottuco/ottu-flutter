# ottu_flutter

Ottu Flutter SDK containing repo

## Downloading the Plugin

1. In the merchant application go to the **pubspec.yaml** file and find the dependencies: tag.
2. Below that tag add dependency tag with **ottu_flutter_checkout:** name.
3. Below that dependency name add git dependency to the Flutter Ottu SDK with this url: **git@github.com:ottuco/ottu-flutter.git**
4. Run `flutter pub get` command

## Sample
`dependencies:
    flutter:
    sdk: flutter

    ottu_flutter_checkout:
    #to use ottu_flutter_checkout sdk from the local source uncomment line below and comment 3 lines with git specification
    #path: ../ottu_flutter_checkout
    git:
        url: git@github.com:ottuco/ottu-flutter.git
        ref: main
`
