//
//  FloatingTabBar.swift
//  FloatingTabBarController
//
//  Created by Emilio Peláez on 25/4/19.
//

import UIKit
import CGMath

public protocol FloatingTabBarDelegate: class {
	func floatingTabBarDidSelect(item: FloatingTabItem, index: Int)
}

open class FloatingTabBar: UIView {
	
	open weak var delegate: FloatingTabBarDelegate?
	
	open var position: CGFloat = 0 {
		didSet { setNeedsLayout() }
	}
	
	open var items: [FloatingTabItem] = [] {
		didSet {
			imageViews = items.map { (UIImageView(image: $0.selectedImage), UIImageView(image: $0.normalImage)) }
		}
	}
	
	open var spacing: CGFloat = 3 {
		didSet { setNeedsLayout() }
	}
	
	open var radius: CGFloat = 10 {
		didSet { setNeedsLayout() }
	}
	open var bottomRadius: CGFloat = 20 {
		didSet { setNeedsLayout() }
	}
	private let bottomMargin: CGFloat = 5
	open var topMargin: CGFloat {
		return (frame.height - (bottomMargin + spacing)) / 2 - radius
	}
	
	override var maskPath: UIBezierPath? {
		set { blurView.maskPath = newValue }
		get { return blurView.maskPath }
	}
	
	open override var backgroundColor: UIColor? {
		set { blurView.backgroundColor = newValue }
		get { return blurView.backgroundColor }
	}
	
	open var visualEffect: UIVisualEffect? {
		set { blurView.effect = newValue }
		get { return blurView.effect }
	}
	
	private var imageViews: [(selected: UIImageView, deselected: UIImageView)] = [] {
		didSet {
			oldValue.forEach {
				$0.selected.removeFromSuperview()
				$0.deselected.removeFromSuperview()
			}
			imageViews.forEach {
				blurView.contentView.addSubview($0.selected)
				blurView.contentView.addSubview($0.deselected)
			}
			setNeedsLayout()
		}
	}
	
	private let blurView: UIVisualEffectView = {
		if #available(iOS 13.0, *) {
			return UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
		} else {
			return UIVisualEffectView(effect: UIBlurEffect(style: .light))
		}
	}()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	private func initialize() {
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2)
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.25
		
		isOpaque = false
		backgroundColor = .clear
		
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(recognizeTap(with:)))
		addGestureRecognizer(recognizer)
		
		addSubview(blurView)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		blurView.frame = bounds
		createPath()
		layoutIcons()
	}
	
	func createPath() {
		guard !items.isEmpty else {
			maskPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
			return
		}
		
		let position = items.count > 4 ? self.position.clamped(min: 0, max: CGFloat(items.count - 1)) : self.position
		
		let circleSide: CGFloat = bounds.height - (bottomMargin + spacing)
		
		let background = UIBezierPath()
		let radiusH = CGPoint(x: radius, y: 0)
		let radiusV = CGPoint(x: 0, y: radius)
		let circleH = CGPoint(x: circleSide / 2, y: 0)
		let circleV = CGPoint(x: 0, y: circleSide / 2)
		let bottomH = CGPoint(x: bottomRadius, y: 0)
		let bottomV = CGPoint(x: 0, y: bottomRadius)
		
		let circleX = bounds.width / CGFloat(items.count + 1) * (position + 1)
		let topX = CGPoint(x: circleX, y: bounds.minY)
		
		background.move(to: topX - circleH - CGPoint(x: spacing, y: 0) - radiusH + circleV - radiusV)
		background.addArc(withCenter: topX - circleH - CGPoint(x: spacing, y: 0) - radiusH + circleV,
											radius: radius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
		background.addArc(withCenter: topX + circleV,
											radius: circleSide / 2 + spacing, startAngle: .pi, endAngle: 0, clockwise: false)
		background.addArc(withCenter: topX + circleH + CGPoint(x: spacing, y: 0) + radiusH + circleV,
											radius: radius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
		background.addArc(withCenter: bounds.topRight - radiusH + circleV,
											radius: radius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
		background.addLine(to: bounds.bottomRight - radiusV)
		background.addArc(withCenter: bounds.bottomRight - bottomH - bottomV,
											radius: bottomRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
		background.addLine(to: bounds.bottomLeft + radiusH)
		background.addArc(withCenter: bounds.bottomLeft + bottomH - bottomV,
											radius: bottomRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
		background.addLine(to: bounds.topLeft + circleV)
		background.addArc(withCenter: bounds.topLeft + radiusH + circleV,
											radius: radius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
		background.close()
		
		let circleCenter = CGPoint(x: circleX, y: circleV.y)
		let circle = UIBezierPath(ovalIn: CGRect(center: circleCenter, size: CGSize(side: circleSide)))
		
		let path = UIBezierPath()
		path.append(background)
		path.append(circle)
		
		maskPath = path
	}
	
	func layoutIcons() {
		let position = items.count > 4 ? self.position.clamped(min: 0, max: CGFloat(items.count - 1)) : self.position
		
		let rect = bounds
		let circleSide: CGFloat = rect.height - (bottomMargin + spacing)
		let circleV = CGPoint(x: 0, y: circleSide / 2)
		let circleX = rect.width / CGFloat(items.count + 1) * (position + 1)
		let circleCenter = CGPoint(x: circleX, y: circleV.y)
		
		let topSpacing = rect.minY + circleV.y - radius
		let iconsYOffset = topSpacing + (rect.height - topSpacing) / 2
		
		imageViews.enumerated().forEach {
			let index = CGFloat($0.offset)
			let selected = $0.element.selected
			let deselected = $0.element.deselected
			
			let distance = abs(index - position)
			
			selected.center = circleCenter
			deselected.center = CGPoint(x: rect.width / CGFloat(items.count + 1) * (index + 1), y: iconsYOffset)
			
			let firstStep: CGFloat = 0.5
			let secondStep: CGFloat = 0.5
			if distance < firstStep {
				selected.alpha = inverseLerp(start: firstStep, end: 0, value: distance)
				deselected.alpha = 0
			} else if distance < secondStep {
				selected.alpha = 0
				deselected.alpha = 0
			} else if distance < 1 {
				selected.alpha = 0
				deselected.alpha = inverseLerp(start: secondStep, end: 1, value: distance)
			} else {
				selected.alpha = 0
				deselected.alpha = 1
			}
		}
	}
	
	open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		return (maskPath?.contains(point) ?? true) ? self : nil
	}
	
	@objc func recognizeTap(with recognizer: UITapGestureRecognizer) {
		guard recognizer.state == .recognized, !items.isEmpty else { return }
		let positionX = recognizer.location(in: recognizer.view).x
		let index = Int(round((positionX / frame.width * CGFloat(items.count + 1)) - 1))
		guard (0..<items.count).contains(index) else { return }
		delegate?.floatingTabBarDidSelect(item: items[index], index: index)
	}
	
}
