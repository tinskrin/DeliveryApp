//
//  MenuTableHeaderView.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import UIKit

protocol IMenuTableHeaderViewOutput: AnyObject {
	func didSelectItem(at index: Int)
}

class MenuTableHeaderView: UITableViewHeaderFooterView {

	private let categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.estimatedItemSize = .init(width: 88, height: 32)
		layout.sectionInset = .init(top: 24, left: 16, bottom: 24, right: 16)
		let bannerImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		bannerImageCollectionView.backgroundColor = .clear
		bannerImageCollectionView.showsHorizontalScrollIndicator = false
		bannerImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
		return bannerImageCollectionView
	}()

	private var categories: [String] = []

	weak var delegate: IMenuTableHeaderViewOutput?

	// MARK: - Init

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func configure(with categories: [String]) {
		if categories == self.categories { return }
		self.categories = categories
		categoriesCollectionView.reloadData()
		selectItem(at: 0)
	}

	func selectItem(at index: Int) {
		guard !categories.isEmpty, index < categories.count else { return }
		let indexPath = IndexPath(item: index, section: 0)
		categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		categoriesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
	}

	// MARK: - Private

	private func setupView(){
		addSubview(categoriesCollectionView)
		categoriesCollectionView.dataSource = self
		categoriesCollectionView.delegate = self
		categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
	}

	private func setupConstraints(){
		NSLayoutConstraint.activate(
			[
				categoriesCollectionView.topAnchor.constraint(equalTo: topAnchor),
				categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
				categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
				categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
			]
		)
	}
}

// MARK: - UICollectionViewDataSource

extension MenuTableHeaderView: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categories.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell",
															for: indexPath) as? CategoriesCollectionViewCell else { return UICollectionViewCell() }
		cell.configure(title: categories[indexPath.row])

		return cell
	}
}

// MARK: - UICollectionViewDelegate

extension MenuTableHeaderView: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.didSelectItem(at: indexPath.row)
		collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
}
