// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NotificationView",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "NotificationView", targets: ["NotificationView"]),
    ],
    targets: [
        .target(
            name: "NotificationView",
            dependencies: [],
            path: "NotificationView/Classes"
         )
    ]
)
