//
//  Comparable.swift
//  CGMath
//
//  Created by Emilio Peláez on 26/6/18.
//

import Foundation

extension Comparable {
	public mutating func clamp(min: Self, max: Self) {
		self = clamped(min: min, max: max)
	}
	
	public func clamped(min: Self, max: Self) -> Self {
		return Swift.max(min, Swift.min(max, self))
	}
}
