// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OMURL",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OMURL",
            targets: ["OMURL"]),
    ],
    dependencies: [
            .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.1"),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OMURL",
            dependencies: [
                .product(name: "SwiftSoup", package: "SwiftSoup"),
            ]),
        .testTarget(
            name: "OMURLTests",
            dependencies: ["OMURL"]),
    ]
)
