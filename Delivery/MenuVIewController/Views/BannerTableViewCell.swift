//
//  BannerTableViewCell.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

	private let bannerImageCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = .init(width: 300, height: 112)
		layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
		let bannerImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		bannerImageCollectionView.backgroundColor = .clear
		bannerImageCollectionView.showsHorizontalScrollIndicator = false
		bannerImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
		return bannerImageCollectionView
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

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if self.point(inside: point, with: event) {
			return bannerImageCollectionView
		}
		return super.hitTest(point, with: event)
	}

	// MARK: - Private

	private func setupView(){
		bannerImageCollectionView.dataSource = self
		bannerImageCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.reusedId)
		addSubview(bannerImageCollectionView)
	}

	private func setupConstraints(){
		NSLayoutConstraint.activate(
			[
				bannerImageCollectionView.topAnchor.constraint(equalTo: topAnchor),
				bannerImageCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
				bannerImageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
				bannerImageCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
			]
		)
	}
}

// MARK: - UICollectionViewDataSource

extension BannerTableViewCell: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.reusedId, for: indexPath)
		return cell
	}
}
