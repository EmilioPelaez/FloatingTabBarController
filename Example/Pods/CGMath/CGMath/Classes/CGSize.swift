//
//  CGSize.swift
//  CGMath
//
//  Created by Emilio Peláez on 26/6/18.
//

import CoreGraphics

extension CGSize {
	public var aspectRatio: CGFloat {
		return width / height
	}
	
	public init(aspectRatio: CGFloat, maxSize size: CGSize) {
		let sizeRatio = size.aspectRatio
		if aspectRatio > sizeRatio {
			self.init(width: size.width, height: size.width / aspectRatio)
		} else {
			self.init(width: size.height * aspectRatio, height: size.height)
		}
	}
	
	public init(side: CGFloat) {
		self.init(width: side, height: side)
	}
	
	public var asPoint: CGPoint {
		return convert()
	}
	
	public var asVector: CGVector {
		return convert()
	}
}
