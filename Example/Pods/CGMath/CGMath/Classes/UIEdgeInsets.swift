//
//  UIEdgeInsets.swift
//  CGMath
//
//  Created by Emilio Peláez on 27/7/18.
//

import UIKit

extension UIEdgeInsets {
	
	public var horizontal: CGFloat {
		return left + right
	}
	
	public var vertical: CGFloat {
		return top + bottom
	}
	
}
