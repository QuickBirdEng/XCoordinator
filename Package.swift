// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "XCoordinator",
    platforms: [.iOS(.v16), .tvOS(.v16)],
    products: [
        .library(
            name: "XCoordinator",
            targets: ["XCoordinator"]),
        .library(
            name: "XCoordinatorRx",
            targets: ["XCoordinatorRx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
    ],
    targets: [
        .target(
            name: "XCoordinator",
            dependencies: []),
        .target(
            name: "XCoordinatorRx",
            dependencies: ["XCoordinator", "RxSwift"]),
    ]
)
