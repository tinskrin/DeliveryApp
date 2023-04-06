//
//  PizzaService.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import Foundation

protocol IPizzaService {
	func getAllGoods(callback: @escaping ([Categories]?) -> Void)
	func getImageData(imageName: String, callback: @escaping (Data?) -> Void)
}

class PizzaService: IPizzaService {

	private var baseUrl: URL! = URL(string: "https://eda.yandex.ru")
	private var apiUrl: URL! = URL(string: "https://eda.yandex.ru/api/v2")

	private let storage: IMenuDataStorage

	init(storage: IMenuDataStorage) {
		self.storage = storage
	}

	func getAllGoods(callback: @escaping ([Categories]?) -> Void) {
		var url = apiUrl.appending(path: "menu/retrieve/papa_irfpt")
		url.append(queryItems: [URLQueryItem(name: "regionId", value: "1"),
								URLQueryItem(name: "autoTranslate", value: "false")])
		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		if let data = storage.getStore() {
			callback(data.payload.categories)
		}

		DispatchQueue.global().async { [weak self] in
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				do {
					guard let data = data else { return callback(nil) }
					let model = try JSONDecoder().decode(Goods.self, from: data)
					self?.storage.saveStore(model)
					callback(model.payload.categories)
				} catch {
					print(error)
					callback(nil)
				}
			}
			task.resume()
		}
	}

	func getImageData(imageName: String, callback: @escaping (Data?) -> Void) {
		let imageName = imageName.replacingOccurrences(of: "-{w}x{h}", with: "")
		let url = baseUrl.appending(path: imageName)
		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		DispatchQueue.global().async { [weak self] in
			if let image = self?.storage.getImage(for: imageName) {
				callback(image)
				return
			}
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				guard let data = data else { return callback(nil) }
				self?.storage.saveImage(for: imageName, data: data)
				callback(data)
			}
			task.resume()
		}
	}
}
