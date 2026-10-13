// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "zego_uikit_signaling_plugin",
    platforms: [.iOS("13.0")],
    products: [.library(name: "zego-uikit-signaling-plugin", targets: ["zego_uikit_signaling_plugin"])],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "zego_uikit_signaling_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            cSettings: [.headerSearchPath("include/zego_uikit_signaling_plugin")]
        )
    ]
)
