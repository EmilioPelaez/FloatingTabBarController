//
//  ViewController.swift
//  FloatingTabBarController
//
//  Created by EmilioPelaez on 04/25/2019.
//  Copyright (c) 2019 EmilioPelaez. All rights reserved.
//

import UIKit
import FloatingTabBarController

class ViewController: FloatingTabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = UIColor(white: 0.75, alpha: 1)
		
		viewControllers = (1...3).map { "Tab\($0)" }.map {
			let selected = UIImage(named: $0 + "_Large")!
			let deselected = UIImage(named: $0 + "_Small")!
			let controller = storyboard!.instantiateViewController(withIdentifier: $0)
			controller.title = $0
			controller.view.backgroundColor = UIColor(named: $0)
			controller.floatingTabItem = FloatingTabItem(selectedImage: selected, deselectedImage: deselected)
			return controller
		}
		
	}
	
}
