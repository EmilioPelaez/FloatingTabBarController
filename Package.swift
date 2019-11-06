// swift-tools-version:5.1

import PackageDescription

let package = Package(
	name: "FloatingTabBarController",
	platforms: [
		.iOS(.v11),
	],
	products: [
		.library(name: "FloatingTabBarController", targets: ["FloatingTabBarController"])
	],
	dependencies: [
			.package(url: "https://EmilioPelaez@github.com/EmilioPelaez/CGMath.git", from: "1.0.0"),
	],
	targets: [
		.target(name: "FloatingTabBarController", dependencies: ["CGMath"])
	]
)
