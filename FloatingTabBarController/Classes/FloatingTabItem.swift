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
	public let deselectedImage: UIImage
	
	public init(selectedImage: UIImage, deselectedImage: UIImage) {
		self.selectedImage = selectedImage
		self.deselectedImage = deselectedImage
	}
	
	public init(image: UIImage) {
		self.selectedImage = image
		self.deselectedImage = image
	}
	
}
