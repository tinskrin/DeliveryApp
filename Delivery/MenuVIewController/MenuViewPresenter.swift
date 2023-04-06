//
//  MenuViewPresenter.swift
//  Delivery
//
//  Created by tinskrin on 04.04.2023.
//

import Foundation

protocol IMenuViewPresenter: AnyObject {
	func viewDidLoad()
	func numberOfRowsInSection(_ section: Int) -> Int
	func getFoodCategories() -> [String]
	func getData(for row: Int) -> ProductTableViewCell.ViewModel
	func getImage(for row: Int, callback: @escaping (Data?) -> Void)
	func didSelectSection(_ section: Int)
	func willDisplayCell(at index: Int)
}

final class MenuViewPresenter {

	weak var view: IMenuView?

	private let service: IPizzaService

	private var workItem: DispatchWorkItem?
	private var allGoods: [Categories]?
	private var currentSection = -1
	private var currentRow = -1

	// MARK: - Init

	init(service: IPizzaService) {
		self.service = service
	}

	// MARK: - Private

	private func requestProducts() {
		service.getAllGoods { [weak self] goods in
			guard let self else { return }
			DispatchQueue.main.async {
				self.allGoods = goods
				self.view?.reloadTableView()
			}
		}
	}

	private func getProduct(for row: Int) -> Item? {
		guard let allGoods else { return nil }
		var count = 0
		for item in allGoods {
			if row >= count + item.items.count {
				count += item.items.count
			} else {
				let index = row - count
				let product = item.items[index]
				return product
			}
		}
		return nil
	}

	private func getProductIndexPath(for section: Int) -> IndexPath? {
		guard let allGoods else { return nil }
		var count = 0
		for (index, item) in allGoods.enumerated() {
			if section > index {
				count += item.items.count
			} else {
				return IndexPath(item: count, section: 1)
			}
		}
		return nil
	}

	private func updateSelectSectionIfNeeded(for row: Int) {
		guard let allGoods else { return }
		let row = currentRow < row ? row : row + 1
		var count = 0
		for (index, item) in allGoods.enumerated() {
			if row >= count + item.items.count {
				count += item.items.count
			} else if row <= count + item.items.count && currentSection != index {
				currentSection = index
				currentRow = row
				view?.changeMenuSection(for: index)
				break
			} else {
				break
			}
		}
	}
}

// MARK: - IMenuViewPresenter

extension MenuViewPresenter: IMenuViewPresenter {

	func viewDidLoad() {
		requestProducts()
	}

	func numberOfRowsInSection(_ section: Int) -> Int {
		guard let allGoods else { return 0 }
		return allGoods.reduce(0, { $0 + $1.items.count })
	}

	func getData(for row: Int) -> ProductTableViewCell.ViewModel {
		if let product = getProduct(for: row) {
			return .init(name: product.name,
						 description: product.description,
						 price: product.price)
		}

		return .init()
	}

	func getFoodCategories() -> [String] {
		guard let allGoods else { return [] }
		return allGoods.reduce([]) { $0 + [$1.name] }
	}

	func getImage(for row: Int, callback: @escaping (Data?) -> Void) {
		if let product = getProduct(for: row) {
			service.getImageData(imageName: product.picture.uri) { data in
				DispatchQueue.main.async {
					callback(data)
				}
			}
		} else {
			callback(nil)
		}
	}

	func didSelectSection(_ section: Int) {
		if let indexPath = getProductIndexPath(for: section) {
			view?.scrollTableView(for: indexPath)
		}
	}

	func willDisplayCell(at index: Int) {
		workItem?.cancel()
		workItem = DispatchWorkItem { [weak self] in
			self?.updateSelectSectionIfNeeded(for: index)
		}
		guard let workItem else { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
	}
}
