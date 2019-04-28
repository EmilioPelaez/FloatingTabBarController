//
//  ViewControllerCollectionViewCell.swift
//  FloatingTabBarController
//
//  Created by Emilio Peláez on 25/4/19.
//

import UIKit

class ViewControllerCollectionViewCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	func initialize() {
		backgroundColor = .clear
		isOpaque = false
	}
	
	var viewController: UIViewController? {
		didSet {
			if oldValue?.view.superview == contentView {
				oldValue?.view.removeFromSuperview()
			}
			
			if let view = viewController?.view {
				contentView.addSubview(view)
				view.frame = contentView.bounds
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		viewController?.view.frame = contentView.bounds
	}
}
