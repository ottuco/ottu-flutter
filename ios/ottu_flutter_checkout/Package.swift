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
         .package(name: "ottu_checkout_sdk", url: "https://github.com/ottuco/ottu-ios", from: "2.1.5")
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
