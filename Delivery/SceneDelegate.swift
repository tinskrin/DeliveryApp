//
//  SceneDelegate.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		window.rootViewController = createTabBarController()
		window.makeKeyAndVisible()
		self.window = window
	}

	func createTabBarController() -> UITabBarController {
		let tabBarController = UITabBarController()
		UITabBar.appearance().backgroundColor = .white
		tabBarController.viewControllers = [
			createMenuViewController(),
			createOtherViewControllers(title: "Контакты", image: "Contacts"),
			createOtherViewControllers(title: "Профиль", image: "Profile"),
			createOtherViewControllers(title: "Корзина", image: "Cart")
		]
		tabBarController.tabBar.tintColor = .systemRed
		return tabBarController
	}

	func createMenuViewController() -> UINavigationController {
		let assembly = MenuViewAssembly()
		let service = PizzaService(storage: MenuDataStorage())
		let viewController = assembly.assemble(pizzaService: service)

		viewController.tabBarItem = UITabBarItem(title: "Меню", image: UIImage(named: "Menu"), tag: 0)

		let navigationController = UINavigationController(rootViewController: viewController)
		return navigationController
	}

	func createOtherViewControllers(title: String, image: String) -> UINavigationController {
		let viewController = ProfileViewController()
		viewController.title = title
		viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: image), tag: 0)
		return UINavigationController(rootViewController: viewController)
	}
}
