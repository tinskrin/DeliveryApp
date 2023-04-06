//
//  ProductTableViewCell.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

	struct ViewModel {
		let image: Data?
		let name: String?
		let description: String?
		let price: Int?

		init(image: Data? = nil,
			 name: String? = nil,
			 description: String? = nil,
			 price: Int? = nil) {
			self.image = image
			self.name = name
			self.description = description
			self.price = price
		}
	}

	private let pizzaImageView: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()

	private let pizzasName: UILabel = {
		let pizzasName = UILabel()
		pizzasName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		pizzasName.numberOfLines = 2
		pizzasName.translatesAutoresizingMaskIntoConstraints = false
		return pizzasName
	}()

	private let priceLabel: UILabel = {
		let price = UILabel()
		price.layer.borderColor = .customRed
		price.layer.borderWidth = 1
		price.layer.cornerRadius = 6
		price.textColor = .customRed
		price.font = .custom13Regular
		price.textAlignment = .center
		price.translatesAutoresizingMaskIntoConstraints = false
		return price
	}()

	private let pizzasDescription: UILabel = {
		let pizzasDescription = UILabel()
		pizzasDescription.translatesAutoresizingMaskIntoConstraints = false
		pizzasDescription.font = .custom13Regular
		pizzasDescription.numberOfLines = 5
		pizzasDescription.textColor = UIColor(red: 0.67, green: 0.67, blue: 0.68, alpha: 1.00)
		return pizzasDescription
	}()

	private let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .separatorColor
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Override

	override func prepareForReuse() {
		layer.mask = nil
		pizzaImageView.image = nil
		super.prepareForReuse()
	}

	// MARK: - Public

	func configure(_ model: ProductTableViewCell.ViewModel) {
		if let image = model.image {
			pizzaImageView.image = UIImage(data: image)
		}
		pizzasName.text = model.name
		pizzasDescription.text = model.description
		if let price = model.price {
			priceLabel.text = "\(price) p"
		}
	}

	func configure(image: Data?) {
		if let image {
			pizzaImageView.image = UIImage(data: image)
		}
	}

	// MARK: - Private

	private func setupView(){
		addSubview(pizzaImageView)
		addSubview(pizzasName)
		addSubview(pizzasDescription)
		addSubview(priceLabel)
		addSubview(separatorView)
	}

	private func setupConstraints(){
		NSLayoutConstraint.activate(
			[
				pizzaImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
				pizzaImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
				pizzaImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
				pizzaImageView.widthAnchor.constraint(equalToConstant: 132),
				pizzaImageView.heightAnchor.constraint(equalToConstant: 132),

				pizzasName.topAnchor.constraint(equalTo: topAnchor, constant: 32),
				pizzasName.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor,constant: 32),
				pizzasName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

				pizzasDescription.topAnchor.constraint(equalTo: pizzasName.bottomAnchor, constant: 8),
				pizzasDescription.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor,constant: 32),
				pizzasDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),


				priceLabel.topAnchor.constraint(equalTo: pizzasDescription.bottomAnchor, constant: 16),
				priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
				priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: separatorView.topAnchor, constant: -15),
				priceLabel.heightAnchor.constraint(equalToConstant: 32),
				priceLabel.widthAnchor.constraint(equalToConstant: 87),

				separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
				separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
				separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
				separatorView.heightAnchor.constraint(equalToConstant: 1)
			]
		)
	}
}
