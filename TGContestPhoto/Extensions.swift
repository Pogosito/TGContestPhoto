//
//  Extensions.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 09.07.2023.
//

import UIKit

// MARK: - CGPoint

extension CGPoint {

	static func /(lhs: CGPoint, rhs: Double) -> CGPoint {
		CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
	}

	static func /(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		CGPoint(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
	}

	static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}

	static func +(lhs: CGPoint, rhs: Double) -> CGPoint {
		CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
	}

	static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

// MARK: - CGSize

extension CGSize {

	static func *(lhs: CGSize, rhs: Double) -> CGSize {
		CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
	}

	static func /(lhs: CGSize, rhs: CGSize) -> CGSize {
		CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
	}

	static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
		CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
	}
}

// MARK: - UIView

extension UIView {

	func setAnchorPoint(_ point: CGPoint) {

		var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
		var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

		newPoint = newPoint.applying(transform)
		oldPoint = oldPoint.applying(transform)

		var position = layer.position

		position.x -= oldPoint.x
		position.x += newPoint.x

		position.y -= oldPoint.y
		position.y += newPoint.y

		layer.position = position
		layer.anchorPoint = point
	}
}
