//
//  MenuViewAssembly.swift
//  Delivery
//
//  Created by tinskrin on 04.04.2023.
//

import UIKit

final class MenuViewAssembly {

	func assemble(pizzaService: IPizzaService) -> UIViewController {
		let presenter = MenuViewPresenter(service: pizzaService)
		let viewController = MenuViewController(presenter: presenter)
		presenter.view = viewController
		return viewController
	}
}
