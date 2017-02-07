import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 4),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 4),
        .Package(url: "https://github.com/vapor/fluent.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/vapor/sqlite-driver.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", "2.2.1"),
    ])
