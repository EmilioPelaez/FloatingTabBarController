//
//  DoubleListRepresentable.swift
//  CGMath
//
//  Created by Emilio Peláez on 26/6/18.
//

import Foundation
import UIKit

public protocol ExpressibleByCGFloatListLiteral {
	init(floatList: [CGFloat])
}

public protocol CGFloatListConvertible {
	var floatList: [CGFloat] { get set }
}

public typealias CGFloatListRepresentable = ExpressibleByCGFloatListLiteral & CGFloatListConvertible

extension CGFloatListConvertible {
	public var magnitude: CGFloat {
		return sqrt(floatList.reduce(0) { $0 + $1 * $1 })
	}
	
	public mutating func normalize() {
		let magnitude = self.magnitude
		floatList = floatList.map { $0 / magnitude }
	}
	
	//	These convert methods initialize another ExpressibleByCGFloatListLiteral using the floatList in the
	//	current object. The order will be preserved so if the objects have a different amount of elements,
	//	eg. CGSize to CGRect, you might find the results not useful. The ideal use is to convert objects of
	//	the same dimensions.
	//	If the receiving object doesn't handle receiving less elements than necessary to be initialized, it
	//	might cause a crash. All default implementations handle that case properly to avoid a crash. Any missing
	//	values will be assumed to be 0
	
	//	Example usage:
	//	let point = CGSize(side: 100).convert(to: CGPoint.self)
	public func convert<T: ExpressibleByCGFloatListLiteral>(to type: T.Type) -> T {
		return T(floatList: floatList)
	}
	
	//	Example usage:
	//	let point: CGPoint = CGSize(side: 100).convert()
	public func convert<T: ExpressibleByCGFloatListLiteral>() -> T {
		return T(floatList: floatList)
	}
	
}

extension ExpressibleByCGFloatListLiteral where Self: CGFloatListConvertible {
	public var normalized: Self {
		let magnitude = self.magnitude
		let array = floatList.map { $0 / magnitude }
		return type(of: self).init(floatList: array)
	}
}

public func lerp<T: CGFloatListRepresentable>(start: T, end: T, progress: CGFloat) -> T {
	return T(floatList: zip(start.floatList, end.floatList).map { lerp(start: $0, end: $1, progress: progress) })
}
public func lerp<T: CGFloatListRepresentable>(start: T, end: T, progress: Double) -> T {
	return lerp(start: start, end: end, progress: CGFloat(progress))
}
public func lerp<T: CGFloatListRepresentable>(start: T, end: T, progress: Float) -> T {
	return lerp(start: start, end: end, progress: CGFloat(progress))
}
public func lerp<T: CGFloatListRepresentable>(start: T, end: T, progress: Int) -> T {
	return lerp(start: start, end: end, progress: CGFloat(progress))
}

public func +<T: CGFloatListRepresentable>(lhs: T, rhs: T) -> T {
	return T(floatList: zip(lhs.floatList, rhs.floatList).map(+))
}

public func -<T: CGFloatListRepresentable>(lhs: T, rhs: T) -> T {
	return T(floatList: zip(lhs.floatList, rhs.floatList).map(-))
}

public func *<T: CGFloatListRepresentable>(lhs: T, rhs: CGFloat) -> T {
	return T(floatList: lhs.floatList.map { $0 * rhs })
}
public func *<T: CGFloatListRepresentable>(lhs: T, rhs: Double) -> T {
	return lhs * CGFloat(rhs)
}
public func *<T: CGFloatListRepresentable>(lhs: T, rhs: Float) -> T {
	return lhs * CGFloat(rhs)
}
public func *<T: CGFloatListRepresentable>(lhs: T, rhs: Int) -> T {
	return lhs * CGFloat(rhs)
}

public func /<T: CGFloatListRepresentable>(lhs: T, rhs: CGFloat) -> T {
	return T(floatList: lhs.floatList.map { $0 / rhs })
}
public func /<T: CGFloatListRepresentable>(lhs: T, rhs: Double) -> T {
	return lhs / CGFloat(rhs)
}
public func /<T: CGFloatListRepresentable>(lhs: T, rhs: Float) -> T {
	return lhs / CGFloat(rhs)
}
public func /<T: CGFloatListRepresentable>(lhs: T, rhs: Int) -> T {
	return lhs / CGFloat(rhs)
}

public func += <T: CGFloatListRepresentable>(lhs: inout T, rhs: T) {
	lhs.floatList = zip(lhs.floatList, rhs.floatList).map(+)
}

public func -= <T: CGFloatListRepresentable>(lhs: inout T, rhs: T) {
	lhs.floatList = zip(lhs.floatList, rhs.floatList).map(-)
}

public func *= <T: CGFloatListRepresentable>(lhs: inout T, rhs: CGFloat) {
	lhs.floatList = lhs.floatList.map { $0 * rhs }
}
public func *= <T: CGFloatListRepresentable>(lhs: inout T, rhs: Double) {
	lhs.floatList = lhs.floatList.map { $0 * CGFloat(rhs) }
}
public func *= <T: CGFloatListRepresentable>(lhs: inout T, rhs: Float) {
	lhs.floatList = lhs.floatList.map { $0 * CGFloat(rhs) }
}
public func *= <T: CGFloatListRepresentable>(lhs: inout T, rhs: Int) {
	lhs.floatList = lhs.floatList.map { $0 * CGFloat(rhs) }
}

public func /= <T: CGFloatListRepresentable>(lhs: inout T, rhs: CGFloat) {
	lhs.floatList = lhs.floatList.map { $0 / rhs }
}
public func /= <T: CGFloatListRepresentable>(lhs: inout T, rhs: Double) {
	lhs.floatList = lhs.floatList.map { $0 / CGFloat(rhs) }
}
public func /= <T: CGFloatListRepresentable>(lhs: inout T, rhs: Float) {
	lhs.floatList = lhs.floatList.map { $0 / CGFloat(rhs) }
}
public func /= <T: CGFloatListRepresentable>(lhs: inout T, rhs: Int) {
	lhs.floatList = lhs.floatList.map { $0 / CGFloat(rhs) }
}
