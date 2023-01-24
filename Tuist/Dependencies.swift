import ProjectDescription

let packages: [Package] = [
  .package(url: "https://github.com/Saik0s/AppDevUtils.git", .branch("main")),
  .package(url: "https://github.com/krzysztofzablocki/Inject.git", .branch("main")),
  .package(url: "https://github.com/KeyboardKit/KeyboardKit.git", .upToNextMajor(from: "6.9.4")),
]

let dependencies = Dependencies(
  swiftPackageManager: .init(packages),
  platforms: [.iOS]
)
