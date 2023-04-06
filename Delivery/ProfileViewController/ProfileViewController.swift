//
//  ProfileViewController.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import UIKit

class ProfileViewController: UIViewController {

	private let technicalLabel: UILabel =  {
		let technicalLabel = UILabel()
		technicalLabel.translatesAutoresizingMaskIntoConstraints = false
		technicalLabel.text = "Экран находится в разработке"
		technicalLabel.textAlignment = .center
		technicalLabel.textColor = .black
		return technicalLabel
	}()
	private let technicalImageView: UIImageView = {
		let technicalimage = UIImage(systemName: "gearshape.2.fill")
		let technicalImageView = UIImageView(image: technicalimage)
		technicalImageView.translatesAutoresizingMaskIntoConstraints = false
		technicalImageView.tintColor = .black
		technicalImageView.contentMode = .scaleAspectFit
		return technicalImageView
	}()

	// MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		setupViews()
		setupConstraints()
    }

	// MARK: - Private

	private func setupViews() {
		view.addSubview(technicalLabel)
		view.addSubview(technicalImageView)
	}

	private func setupConstraints() {
		let sideSpaces: CGFloat = 10
		NSLayoutConstraint.activate(
			[
				technicalLabel.bottomAnchor.constraint(equalTo: technicalImageView.topAnchor, constant: -sideSpaces),
				technicalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideSpaces),
				technicalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideSpaces),

				technicalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
				technicalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				technicalImageView.heightAnchor.constraint(equalToConstant: 50),
				technicalImageView.widthAnchor.constraint(equalToConstant: 50)
			]
		)

	}
}
