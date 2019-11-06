//
//  UIView+MaskPath.swift
//  FloatingTabBarController
//
//  Created by Emilio Peláez on 25/4/19.
//

import UIKit

extension UIView {
	
	@objc var maskPath: UIBezierPath? {
		set {
			let shapeLayer = (layer.mask as? CAShapeLayer) ?? CAShapeLayer()
			shapeLayer.path = newValue?.cgPath
			layer.mask = shapeLayer
		}
		get {
			guard let shapeLayer = layer.mask as? CAShapeLayer, let path = shapeLayer.path else {
				return nil
			}
			return UIBezierPath(cgPath: path)
		}
	}
	
}
