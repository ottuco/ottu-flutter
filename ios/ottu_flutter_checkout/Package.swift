// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ottu_flutter_checkout",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ottu-flutter-checkout", targets: ["ottu_flutter_checkout"])
    ],
    dependencies: [
        .package(name: "ottu_checkout_sdk", url: "git@github.com:ottuco/ottu-flutter-ios.git", branch: "main")

        //for the local usage please uncomment this line and comment line above
        //.package(name: "ottu_checkout_sdk", path: "../../../ottu-ios")
    ],
    targets: [
        .target(
            name: "ottu_flutter_checkout",
            dependencies: [
                .product(name: "ottu_checkout_sdk", package: "ottu_checkout_sdk"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                .headerSearchPath("include/ottu_flutter_checkout")
            ]
        )
    ]
)
