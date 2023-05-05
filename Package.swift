// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "XCoordinator",
    platforms: [.iOS(.v11), .tvOS(.v11)],
    products: [
        .library(
            name: "XCoordinator",
            targets: ["XCoordinator"]),
        .library(
            name: "XCoordinatorRx",
            targets: ["XCoordinatorRx"]),
        .library(
            name: "XCoordinatorCombine",
            targets: ["XCoordinatorCombine"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "XCoordinator",
            dependencies: []),
        .target(
            name: "XCoordinatorRx",
            dependencies: ["XCoordinator", "RxSwift"]),
        .target(
            name: "XCoordinatorCombine",
            dependencies: ["XCoordinator"]),
        .testTarget(
            name: "XCoordinatorTests",
            dependencies: ["XCoordinator", "XCoordinatorRx"]),
    ]
)
