//
//  FloatingTabBarController.swift
//  FloatingTabBarController
//
//  Created by Emilio Peláez on 25/4/19.
//

import UIKit

private let reuseIdentifier = "Cell"

open class FloatingTabBarController: UIViewController {
	
	public let tabBar = FloatingTabBar()
	
	open var useChildNavigationButtons: Bool = true
	open var useChildNavigationTitle: Bool = true
	
	open var viewControllers: [UIViewController] = [] {
		didSet {
			if viewControllers.count > 5 {
				print("WARNING: Using more than five pages is not recommended")
			}
			oldValue.forEach {
				if $0.floatingTabBarController == self { $0.floatingTabBarController = nil }
				stopObserving($0)
			}
			
			viewControllers.forEach {
				addChild($0)
				$0.floatingTabBarController = self
				observe($0)
			}
			
			updateTabBar()
			updateControllers()
			updateBarItems(animated: false)
		}
	}
	
	open var initialIndex = 0
	
	open var progress: CGFloat {
		scrollView.frame.width == 0 ? 0 : scrollView.contentOffset.x / scrollView.frame.width
	}
	
	open var currentIndex: Int { Int(round(progress)) }
	
	open var currentViewController: UIViewController { viewControllers[currentIndex] }
	
	public let scrollView = UIScrollView()
	private let stackView = UIStackView()
	
	var observers: [UIViewController: NSKeyValueObservation] = [:]
	
	deinit {
		viewControllers.forEach {
			if $0.floatingTabBarController == self { $0.floatingTabBarController = nil }
		}
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		configureScrollView()
		configureStackView()
		configureTabBar()
		updateControllers()
		
		updateBarItems(animated: false)
	}
	
	func configureScrollView() {
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.contentInsetAdjustmentBehavior = .never
		view.addSubview(scrollView)
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		scrollView.delegate = self
	}
	
	func configureStackView() {
		stackView.axis = .horizontal
		stackView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(stackView)
		stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
	}
	
	var tabBarBottomConstraint: NSLayoutConstraint!
	func configureTabBar() {
		tabBar.delegate = self
		tabBar.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tabBar)
		tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
		view.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: 10).isActive = true
		tabBar.widthAnchor.constraint(equalTo: tabBar.heightAnchor, multiplier: 4.5).isActive = true
		tabBarBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: 10)
		tabBarBottomConstraint.isActive = true
	}
	
	func updateControllers() {
		while let first = stackView.arrangedSubviews.first {
			first.removeFromSuperview()
		}
		viewControllers.forEach {
			$0.loadViewIfNeeded()
			stackView.addArrangedSubview($0.view)
			$0.view.translatesAutoresizingMaskIntoConstraints = false
			$0.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
		}
	}
	
	var viewsLaidout = false
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		updateContentInsets()
		
		if !viewsLaidout {
			viewsLaidout = true
			scrollToViewControllerAtIndex(initialIndex, animated: false)
		}
	}
	
	
	open override func viewSafeAreaInsetsDidChange() {
		super.viewSafeAreaInsetsDidChange()
		updateContentInsets()
	}
	
	private func updateContentInsets() {
		if view.safeAreaInsets.bottom == 0 {
			tabBar.bottomRadius = tabBar.radius
			tabBarBottomConstraint.constant = 10
		} else {
			tabBar.bottomRadius = 25
			tabBarBottomConstraint.constant = 0
		}
		view.layoutIfNeeded()
	}
	
	open func updateBarItems(animated: Bool) {
		guard !viewControllers.isEmpty else { return }
		if useChildNavigationTitle {
			navigationItem.titleView = currentViewController.navigationItem.titleView
			navigationItem.title = currentViewController.navigationItem.title
		}
		if useChildNavigationButtons {
			navigationItem.setLeftBarButtonItems(currentViewController.navigationItem.leftBarButtonItems, animated: animated)
			navigationItem.setRightBarButtonItems(currentViewController.navigationItem.rightBarButtonItems, animated: animated)
		}
	}
	
	public func updateTabBar() {
		tabBar.items = viewControllers.map { $0.floatingTabItem ?? .empty }
	}
	
	open func scrollToViewController(_ viewController: UIViewController, animated: Bool) {
		if let index = viewControllers.firstIndex(of: viewController) {
			scrollToViewControllerAtIndex(index, animated: animated)
		}
	}
	
	open func scrollToViewControllerAtIndex(_ index: Int, animated: Bool) {
		if index >= 0 && index <= viewControllers.count - 1 {
			scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0), animated: animated)
		}
	}
	
	open func scrollToNextViewController(_ animated: Bool) {
		if currentIndex < viewControllers.count - 1 {
			scrollToViewControllerAtIndex(currentIndex + 1, animated: animated)
		}
	}
	
	open func scrollToPreviousViewController(_ animated: Bool) {
		if currentIndex > 0 {
			scrollToViewControllerAtIndex(currentIndex - 1, animated: animated)
		}
	}
	
}

extension FloatingTabBarController: UIScrollViewDelegate {
	open func scrollViewDidScroll(_ scrollView: UIScrollView) {
		tabBar.position = progress
		updateBarItems(animated: false)
	}
}

extension FloatingTabBarController: FloatingTabBarDelegate {
	open func floatingTabBarDidSelect(item: FloatingTabItem, index: Int) {
		scrollToViewControllerAtIndex(index, animated: true)
	}
}

extension FloatingTabBarController {
	
	func observe(_ controller: UIViewController) {
		observers[controller] = controller.observe(\.floatingTabItem) { [weak self] _, _ in self?.updateTabBar() }
	}
	
	func stopObserving(_ controller: UIViewController) {
		observers[controller] = nil
	}
	
}
