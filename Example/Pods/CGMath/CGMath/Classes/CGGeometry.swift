//
//  CGGeometry.swift
//  CGMath
//
//  Created by Emilio Peláez on 26/6/18.
//

import CoreGraphics

extension CGPoint: CGFloatListRepresentable {
	public init(floatList: [CGFloat]) {
		let floatList = floatList + [0, 0]
		self.init(x: floatList[0], y: floatList[1])
	}
	
	public var floatList: [CGFloat] {
		get {
			return [x, y]
		}
		set {
			self.x = newValue[0]
			self.y = newValue[1]
		}
	}
}

extension CGSize: CGFloatListRepresentable {
	public init(floatList: [CGFloat]) {
		let floatList = floatList + [0, 0]
		self.init(width: floatList[0], height: floatList[1])
	}
	
	public var floatList: [CGFloat] {
		get {
			return [width, height]
		}
		set {
			self.width = newValue[0]
			self.height = newValue[1]
		}
	}
}

extension CGRect: CGFloatListRepresentable {
	public init(floatList: [CGFloat]) {
		let floatList = floatList + [0, 0, 0, 0]
		self.init(x: floatList[0], y: floatList[1], width: floatList[2], height: floatList[3])
	}
	
	public var floatList: [CGFloat] {
		get { return origin.floatList + size.floatList }
		set {
			self.origin = CGPoint(floatList: newValue)
			self.size = CGSize(width: newValue[2], height: newValue[3])
		}
	}
}

extension CGVector: CGFloatListRepresentable {
	public init(floatList: [CGFloat]) {
		let floatList = floatList + [0, 0]
		self.init(dx: floatList[0], dy: floatList[1])
	}
	
	public var floatList: [CGFloat] {
		get {
			return [dx, dy]
		}
		set {
			self.dx = CGFloat(newValue[0])
			self.dy = CGFloat(newValue[1])
		}
	}
}
