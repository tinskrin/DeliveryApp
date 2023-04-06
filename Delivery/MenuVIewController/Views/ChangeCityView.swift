//
//  ChangeCityView.swift
//  Delivery
//
//  Created by tinskrin on 06.04.2023.
//

import UIKit

final class ChangeCityView: UIView {

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let imageView: UIImageView = {
		let image = UIImage(systemName: "chevron.down")
		let imageView = UIImageView(image: image)
		imageView.tintColor = .black
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func configure(label: String) {
		titleLabel.text = label
	}

	// MARK: - Private

	private func setupViews() {
		addSubview(titleLabel)
		addSubview(imageView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				titleLabel.topAnchor.constraint(equalTo: topAnchor),
				titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
				titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

				imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
				imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
				imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
			]
		)
	}
}
