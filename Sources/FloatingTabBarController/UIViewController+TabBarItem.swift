//
//  UIViewController+TabBarItem.swift
//  FloatingTabBarController
//
//  Created by Emilio Peláez on 25/4/19.
//

import UIKit

extension UIViewController {
	
	struct AssociatedKeys {
		static var floatingTabItem: UInt8 = 0
		static var floatingTabBarController: UInt8 = 1
	}
	
	@objc open var floatingTabItem: FloatingTabItem? {
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.floatingTabItem, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.floatingTabItem) as? FloatingTabItem
		}
	}
	
	@objc open var floatingTabBarController: FloatingTabBarController? {
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.floatingTabBarController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
		}
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.floatingTabBarController) as? FloatingTabBarController
		}
	}
	
}
