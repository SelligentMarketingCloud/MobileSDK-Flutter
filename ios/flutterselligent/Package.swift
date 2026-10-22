// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutterselligent",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "flutterselligent", targets: ["flutterselligent"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/SelligentMarketingCloud/MobileSDK-iOS.git",
            exact: "3.10.1"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "FlutterSelligentMobileSDK",
            path: "FlutterSelligentMobileSDK.xcframework"
        ),
        .target(
            name: "flutterselligent",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SelligentMobileSDK", package: "MobileSDK-iOS"),
                "FlutterSelligentMobileSDK",
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
