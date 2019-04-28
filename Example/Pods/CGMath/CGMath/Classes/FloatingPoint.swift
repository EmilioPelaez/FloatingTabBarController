//
//  FloatingPoint.swift
//  CGMath
//
//  Created by Emilio Peláez on 26/6/18.
//

import Foundation

public func lerp<T: FloatingPoint>(start: T, end: T, progress: T) -> T {
	return (1 - progress) * start + progress * end
}

public func inverseLerp<T: FloatingPoint>(start: T, end: T, value: T) -> T {
	return (value - start) / (end - start)
}

extension FloatingPoint {
	
	public mutating func clamp(min: Self = 0, max: Self = 1) {
		self = clamped(min: min, max: max)
	}
	
	public func clamped(min: Self = 0, max: Self = 1) -> Self {
		return Swift.max(min, Swift.min(max, self))
	}
	
	public func remap(from fromRange: (start: Self, end: Self), to toRange: (start: Self, end: Self)) -> Self {
		let t = inverseLerp(start: fromRange.start, end: fromRange.end, value: self)
		return lerp(start: toRange.start, end: toRange.end, progress: t)
	}
}
