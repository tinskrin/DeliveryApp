//
//  BannerCollectionViewCell.swift
//  Delivery
//
//  Created by tinskrin on 06.04.2023.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

	static let reusedId = "BannerCollectionViewCell"
	
	private let mainImageView: UIImageView = {
		let imageView = UIImageView()
		let imagef = UIImage(named: "firstBanner")
		imageView.image = imagef
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 10
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private

	private func setupView() {
		addSubview(mainImageView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				mainImageView.topAnchor.constraint(equalTo: topAnchor),
				mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
				mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
				mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
			]
		)
	}
}
