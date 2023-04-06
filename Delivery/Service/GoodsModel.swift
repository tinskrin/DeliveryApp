//
//  GoodsModel.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import Foundation

struct Goods: Codable {
	let payload: Payload
}

struct Payload: Codable {
	let categories: [Categories]
}

struct Categories: Codable {
	let name: String
	let items: [Item]
}

struct Item: Codable {
	let name: String
	let description: String?
	let price: Int
	let picture: Picture
}

struct Picture: Codable {
	let uri: String
}
