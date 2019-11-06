// swift-tools-version:5.2

import PackageDescription

let package = Package(
	name: "FloatingTabBarController",
	platforms: [
		.iOS(.v11),
	],
	products: [
		.library(name: "FloatingTabBarController", targets: ["FloatingTabBarController"])
	],
	targets: [
		.target(name: "FloatingTabBarController"),
		.testTarget(name: "FloatingTabBarController", dependencies: ["FloatingTabBarController"])
	]
)