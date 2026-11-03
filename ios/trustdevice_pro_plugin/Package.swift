// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "trustdevice_pro_plugin",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "trustdevice-pro-plugin",
            targets: ["trustdevice_pro_plugin"]
        ),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/trustdecision/trustdevice-pro-ios.git",
            from: "5.3.3"
        ),
    ],
    targets: [
        .target(
            name: "trustdevice_pro_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "TrustDecisionPro", package: "trustdevice-pro-ios"),
            ],
            cSettings: [
                .headerSearchPath("include/trustdevice_pro_plugin"),
            ],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-ObjC"]),
            ]
        ),
    ]
)
