// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/Saik0s/AppDevUtils.git", branch: "main"),
        .package(url: "https://github.com/MacPaw/OpenAI.git", branch: "main"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", branch: "main"),
        .package(url: "https://github.com/KeyboardKit/KeyboardKit.git", from: "6.9.4"),
    ]
)