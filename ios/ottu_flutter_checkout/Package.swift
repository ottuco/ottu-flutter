// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ottu_flutter_checkout",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ottu-flutter-checkout", targets: ["ottu_flutter_checkout"])
    ],
    dependencies: [
        //uncomment for the remote dependency usage
        //.package(name: "ottu_checkout_sdk", url: "git@github.com:ottuco/ottu-flutter-ios.git", branch: "main")

        //for the local usage please uncomment this line and comment line above
        .package(name: "ottu_checkout_sdk", path: "../../../ottu-flutter-ios"),
        .package(url: "https://github.com/scenee/FloatingPanel", from: "2.8.6")
    ],
    targets: [
        .target(
            name: "ottu_flutter_checkout",
            dependencies: [
                .product(name: "ottu_checkout_sdk", package: "ottu_checkout_sdk"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
                .process("Resources")
            ],
            cSettings: [
                .headerSearchPath("include/ottu_flutter_checkout")
            ]
        )
    ]
)
