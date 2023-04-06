//
//  CategoriesCollectionViewCell.swift
//  Delivery
//
//  Created by tinskrin on 05.04.2023.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

	private let categoriesLabel: UILabel = {
		let label = PaddingLabel()
		label.font = .custom13Regular
		label.textColor = .customRed40
		label.textAlignment = .center
		label.edgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var border: CAShapeLayer?

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Override

	override var isSelected: Bool {
		didSet {
			categoriesLabel.font = isSelected ? .custom13Bold : .custom13Regular
			categoriesLabel.textColor = isSelected ? .customRed : .customRed40
			backgroundColor = isSelected ? .customRed20 : .clear
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		roundCorners(corners: .allCorners, radius: 20)
	}

	// MARK: - Public

	func configure(title: String) {
		categoriesLabel.text = title
	}

	// MARK: - Private

	private func setupView() {
		addSubview(categoriesLabel)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				categoriesLabel.topAnchor.constraint(equalTo: topAnchor),
				categoriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
				categoriesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
				categoriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
				heightAnchor.constraint(equalToConstant: 32),
			]
		)
	}

	private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))

		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.path = maskPath.cgPath

		layer.mask = maskLayer

		let frameLayer = CAShapeLayer()
		frameLayer.frame = bounds
		frameLayer.path = maskPath.cgPath
		frameLayer.strokeColor = isSelected ? .clear : .customRed40
		frameLayer.fillColor = nil

		if let border {
			layer.replaceSublayer(border, with: frameLayer)
		} else {
			layer.addSublayer(frameLayer)
		}
		border = frameLayer
	}
}

// MARK: - Custom UILabel

fileprivate class PaddingLabel: UILabel {

	var edgeInsets: UIEdgeInsets = .zero

	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + edgeInsets.left + edgeInsets.right, height: size.height + edgeInsets.top + edgeInsets.bottom)
	}
}
