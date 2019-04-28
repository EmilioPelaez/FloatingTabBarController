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
				$0.removeFromParentViewController()
				if $0.floatingTabBarController == self { $0.floatingTabBarController = nil }
				stopObserving($0)
			}
			
			viewControllers.forEach {
				$0.loadViewIfNeeded()
				addChildViewController($0)
				$0.floatingTabBarController = self
				observe($0)
			}
			
			updateTabBar()
			collectionView.reloadData()
			updateBarItems(animated: false)
		}
	}
	
	open var initialIndex = 0
	
	open var progress: CGFloat {
		guard collectionView.frame.width != 0 else { return 0 }
		return collectionView.contentOffset.x / collectionView.frame.width
	}
	
	open var currentIndex: Int {
		return Int(round(progress))
	}
	
	open var currentViewController: UIViewController {
		return viewControllers[currentIndex]
	}
	
	public let collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		return collectionView
	}()
	
	var collectionViewLayout: UICollectionViewLayout {
		return collectionView.collectionViewLayout
	}
	
	var observers: [UIViewController: NSKeyValueObservation] = [:]
	
	deinit {
		viewControllers.forEach {
			if $0.floatingTabBarController == self { $0.floatingTabBarController = nil }
		}
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		configureCollectionView()
		configureTabBar()
		
		updateBarItems(animated: false)
	}
	
	func configureCollectionView() {
		collectionView.isPagingEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(ViewControllerCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.contentInsetAdjustmentBehavior = .never
		view.addSubview(collectionView)
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		collectionView.dataSource = self
		collectionView.delegate = self
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
	
	var viewsLaidout = false
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureLayout()
		updateContentInsets()
		
		if !viewsLaidout {
			viewsLaidout = true
			collectionView.reloadData()
			
			_ = collectionView.collectionViewLayout.collectionViewContentSize
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
	
	var lastSize: CGSize = .zero
	func configureLayout() {
		guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
			fatalError("Invalid collection view layout")
		}
		
		let verticalInset = collectionView.adjustedContentInset.top + collectionView.adjustedContentInset.bottom
		
		let bounds = view.bounds
		let itemSize = CGSize(width: bounds.width, height: bounds.height - verticalInset)
		
		guard itemSize != lastSize else { return }
		lastSize = itemSize
		
		layout.itemSize = itemSize
		layout.estimatedItemSize = itemSize
		
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = .zero
		
		collectionView.layoutSubviews()
		
		viewControllers.forEach { $0.view.layoutSubviews() }
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
		if let index = viewControllers.index(of: viewController) {
			scrollToViewControllerAtIndex(index, animated: animated)
		}
	}
	
	open func scrollToViewControllerAtIndex(_ index: Int, animated: Bool) {
		if index >= 0 && index <= viewControllers.count - 1 {
			collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
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

extension FloatingTabBarController: UICollectionViewDataSource {
	
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewsLaidout ? 1 : 0
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewControllers.count
	}
	
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ViewControllerCollectionViewCell else {
			fatalError("Cell \(reuseIdentifier) not setup")
		}
		
		cell.viewController = viewControllers[indexPath.item]
		
		return cell
	}
	
}

extension FloatingTabBarController: UICollectionViewDelegate {
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
