//
//  FloatingTabItem.swift
//  FloatingTabBarController
//
//  Created by Emilio Peláez on 25/4/19.
//

import UIKit

open class FloatingTabItem: NSObject {
	
	static let empty = FloatingTabItem(image: UIImage())
	
	// Recommended size 35x35pt
	public let selectedImage: UIImage
	// Recommended size 25x25pt
	public let normalImage: UIImage
	
	public init(selectedImage: UIImage, normalImage: UIImage) {
		self.selectedImage = selectedImage
		self.normalImage = normalImage
	}
	
	public init(image: UIImage) {
		self.selectedImage = image
		self.normalImage = image
	}
	
}
