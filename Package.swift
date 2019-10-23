// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "analytics-server",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.7.0")
    ],
    targets: [
        .target(
            name: "AnalyticsServer",
            dependencies: ["Kitura"]),
        .testTarget(
            name: "AnalyticsServerTests",
            dependencies: ["AnalyticsServer"]),
    ]
)
