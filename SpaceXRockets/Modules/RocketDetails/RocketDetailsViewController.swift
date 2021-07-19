//
//  RocketDetailsViewController.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

import UIKit

final class RocketDetailsViewController: BaseViewController {

    // MARK: - Properties
    
    private lazy var headerView: UIView = {
        let view = UIView()
        imageView.center(to: view)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let size: CGFloat = 130
        imageView.constraintToSize(CGSize(width: size, height: size))
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = viewModel.imageBorderColor.cgColor
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = size / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(RocketDetailsViewCell.self, forCellReuseIdentifier: "RocketDetailsViewCell")
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let viewModel: RocketDetailsViewModelProtocol
    
    // MARK: - Initialization
    
    init(viewModel: RocketDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindings()
    }
}

// MARK: - Private helpers

extension RocketDetailsViewController {

    private func setupView() {
        title = viewModel.navTitle
        headerView.pinToTopAndSides(to: view, height: 150)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension RocketDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RocketDetailsViewCell") as? RocketDetailsViewCell else {
            return UITableViewCell()
        }
        let title = viewModel.cellsInfo[indexPath.row].title
        let description = viewModel.cellsInfo[indexPath.row].description
        cell.setupCell(title: title, description: description)
        return cell
    }
}

// MARK: - bindings

extension RocketDetailsViewController {

    private func bindings() {
        viewModel.image.sink { image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }.store(in: &cancellables)
    }
}
