//
//  CGPoint.swift
//  CGMath
//
//  Created by Emilio Peláez on 26/6/18.
//

import CoreGraphics

extension CGPoint {
	
	public init(direction: CGVector, magnitude: CGFloat) {
		let normalized = direction.normalized
		self.init(x: normalized.dx * magnitude, y: normalized.dy * magnitude)
	}
	
	public var asSize: CGSize {
		return convert()
	}
	
	public var asVector: CGVector {
		return convert()
	}
	
	public var asOffset: UIOffset {
		return convert()
	}
	
}
