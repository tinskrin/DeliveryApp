//
//  MenuViewController.swift
//  Delivery
//
//  Created by tinskrin on 03.04.2023.
//

import UIKit

protocol IMenuView: AnyObject {
	func reloadTableView()
	func scrollTableView(for indexPath: IndexPath)
	func changeMenuSection(for index: Int)
}

class MenuViewController: UIViewController {

	private lazy var menuTableView: UITableView = {
		let menuTableView = UITableView(frame: .zero)
		menuTableView.separatorStyle = .none
		menuTableView.backgroundColor = .customGray
		menuTableView.translatesAutoresizingMaskIntoConstraints = false
		return menuTableView
	}()

	private let presenter: IMenuViewPresenter

	// MARK: - Init

	init(presenter: IMenuViewPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Override

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .customGray
		setupViews()
		setupNavigationBar()
		setupConstraints()
		presenter.viewDidLoad()
	}

	// MARK: - Private

	private func setupViews() {
		setupChangeSity()
		view.addSubview(menuTableView)
		menuTableView.delegate = self
		menuTableView.dataSource = self
		menuTableView.register(BannerTableViewCell.self, forCellReuseIdentifier: "BannerTableViewCell")
		menuTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
		menuTableView.register(MenuTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "MenuTableHeaderView")
	}

	private func setupNavigationBar() {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .customGray
		appearance.shadowColor = .clear
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				menuTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				menuTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			]
		)
	}

	private func setupChangeSity() {
		let sityView = ChangeCityView()
		sityView.configure(label: "Москва")
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sityView)
	}

	private func applyRounding(for cell: UITableViewCell) {
		let path = UIBezierPath(roundedRect: cell.bounds,
								byRoundingCorners:[.topLeft, .topRight],
								cornerRadii: CGSize(width: 20, height:  20))

		let maskLayer = CAShapeLayer()

		maskLayer.path = path.cgPath
		cell.layer.mask = maskLayer
	}
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return presenter.numberOfRowsInSection(section)
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0,
		   let bannerCell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as? BannerTableViewCell {
			bannerCell.backgroundColor = .clear
			bannerCell.selectionStyle = .none
			return bannerCell
		} else if indexPath.section == 1,
				  let pizzaCell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell {
			let model = presenter.getData(for: indexPath.row)
			presenter.getImage(for: indexPath.row) { [weak self] data in
				guard let self else { return }
				if let cell = self.menuTableView.cellForRow(at: indexPath) as? ProductTableViewCell {
					cell.configure(image: data)
				}
			}
			if indexPath.row == 0 {
				applyRounding(for: pizzaCell)
			}
			pizzaCell.configure(model)
			pizzaCell.selectionStyle = .none
			return pizzaCell
		}
		return UITableViewCell()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return 80
		}
		return 0
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 136
		}
		return 180
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1 {
			guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuTableHeaderView") as? MenuTableHeaderView else { return nil}
			let types = presenter.getFoodCategories()
			view.contentView.backgroundColor = .customGray
			view.configure(with: types)
			view.delegate = self
			return view
		}
		return UIView(frame: .zero)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		presenter.willDisplayCell(at: indexPath.row)
	}
}

// MARK: - IMenuView

extension MenuViewController: IMenuView {

	func reloadTableView() {
		menuTableView.reloadData()
	}

	func scrollTableView(for indexPath: IndexPath) {
		menuTableView.scrollToRow(at: indexPath, at: .top, animated: true)
	}

	func changeMenuSection(for index: Int) {
		guard let headerView = menuTableView.headerView(forSection: 1) as? MenuTableHeaderView else { return }
		headerView.selectItem(at: index)
	}
}

// MARK: - IMenuTableHeaderViewOutput

extension MenuViewController: IMenuTableHeaderViewOutput {

	func didSelectItem(at index: Int) {
		presenter.didSelectSection(index)
	}
}
