// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "ottu_flutter_checkout",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ottu-flutter-checkout",
            targets: ["ottu_flutter_checkout"]
        ),
        .library(
            name: "ottu-flutter-checkout-sentry",
            targets: ["ottu_flutter_checkout_sentry"]
        )
    ],
    dependencies: [
        .package(
            name: "ottu_checkout_sdk",
            url: "https://github.com/ottuco/ottu-ios",
            from: "2.2.12-no-deps-8"
        )
    ],
    targets: [
        .target(
            name: "ottu_flutter_checkout",
            dependencies: [
                .product(name: "ottu_checkout_sdk", package: "ottu_checkout_sdk")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
                .process("Resources")
            ],
            cSettings: [
                .headerSearchPath("include/ottu_flutter_checkout")
            ]
        ),
        .target(
            name: "ottu_flutter_checkout_sentry",
            dependencies: [
                .product(name: "ottu_checkout_sdk_sentry", package: "ottu_checkout_sdk")
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
