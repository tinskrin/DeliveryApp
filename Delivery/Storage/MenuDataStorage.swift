//
//  MenuDataStorage.swift
//  Delivery
//
//  Created by tinskrin on 05.04.2023.
//

import Foundation

protocol IMenuDataStorage: AnyObject {

	func getImage(for name: String) -> Data?
	func saveImage(for name: String, data: Data)

	func getStore() -> Goods?
	func saveStore(_ model: Goods)
}

final class MenuDataStorage {

	private let queue = DispatchQueue(label: String(describing: MenuDataStorage.self), qos: .background)

	private var imageStorage: [String: Data] = [:]

	// MARK: - Private

	private func createFolder(path: URL) {
		let path = path.deletingLastPathComponent().path()
		if !(FileManager.default.fileExists(atPath: path)) {
			try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
		}
	}

	private func getPath() throws -> URL {
		try FileManager.default.url(for: .documentDirectory,
									in: .userDomainMask,
									appropriateFor: nil,
									create: false)
	}

	private func getPath(for imageName: String) throws -> URL {
		try getPath().appending(path: imageName.dropFirst())
	}
}

// MARK: - IMenuDataStorage

extension MenuDataStorage: IMenuDataStorage {

	func getImage(for name: String) -> Data? {
		queue.sync {
			return try? FileManager.default.contents(atPath: getPath(for: name).path())
		}
	}

	func saveImage(for name: String, data: Data) {
		queue.async { [weak self] in
			guard let self,
				  let path = try? self.getPath(for: name) else { return }
			self.createFolder(path: path)
			do {
				try data.write(to: path)
			} catch {
				print(error)
			}
		}
	}

	func getStore() -> Goods? {
		queue.sync {
			guard var path = try? getPath() else { return nil }
			path.append(path: "StoredData")
			if let data = FileManager.default.contents(atPath: path.relativePath),
			   let decodedModel = try? JSONDecoder().decode(Goods.self, from: data) {
				return decodedModel
			}
			return nil
		}
	}

	func saveStore(_ model: Goods) {
		queue.async { [weak self] in
			guard let self,
				  var path = try? self.getPath() else { return }
			path.append(path: "StoredData")
			let encodedModel = try? JSONEncoder().encode(model)

			if FileManager.default.fileExists(atPath: path.relativePath),
			   let encodedModel{
				try? FileManager.default.removeItem(at: path)
				try? encodedModel.write(to: path)
			} else if let encodedModel {
				try? encodedModel.write(to: path)
			}
		}
	}
}
