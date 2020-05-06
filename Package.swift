// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCoordinator",
    platforms: [.iOS(.v8)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/antranapp/RxSwift.git", branch: "xcode1141"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
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
