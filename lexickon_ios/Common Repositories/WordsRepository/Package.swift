// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WordsRepository",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_12),
        .tvOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WordsRepository",
            targets: ["WordsRepository"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ReactiveX/RxSwift", .revision("502c905ddbbba144ecca48ad4081a88aa95306a6")),
        .package(url: "https://github.com/Sergey231/LexickonApi.git", from: "0.5.9"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .revision("c244d3275ab5d88c3355c907acd9be687feccb50"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WordsRepository",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                "LexickonApi",
                "Alamofire"
            ])
    ]
)