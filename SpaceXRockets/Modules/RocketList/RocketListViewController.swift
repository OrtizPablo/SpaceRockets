//
//  RocketListViewController.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 31/5/21.
//

import UIKit
import Combine

final class RocketListViewController: BaseViewController {

    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RocketListViewCell.self, forCellReuseIdentifier: "RocketListViewCell")
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "rocketListTableView"
        return tableView
    }()
    
    private let viewModel: RocketListViewModel
    
    // MARK: - Initialization
    
    init(viewModel: RocketListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rockets"
        tableView.pin(to: view)
        placeholderView.delegate = self
        bindViewModel()
        viewModel.onViewReady()
    }
}

// MARK: - Bindings

extension RocketListViewController {

    private func bindViewModel() {
        viewModel.rockets.sink { _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.isLoading.sink { isLoading in
            DispatchQueue.main.async { [weak self] in
                isLoading ? self?.showLoadingIndicator() : self?.stopLoadingIndicator()
            }
        }.store(in: &cancellables)
        
        viewModel.showPlaceholder.sink { isPlaceholderShown in
            DispatchQueue.main.async { [weak self] in
                isPlaceholderShown ? self?.showPlaceholder() : self?.hidePlaceholder()
            }
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate

extension RocketListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.rocketTapped.send(indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension RocketListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rockets.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RocketListViewCell") as? RocketListViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(name: viewModel.rockets.value[indexPath.row].name,
                       firstFlight: viewModel.rockets.value[indexPath.row].firstFlight,
                       active: viewModel.rockets.value[indexPath.row].active)
        cell.accessoryType = .disclosureIndicator
        cell.accessibilityIdentifier = "rocketListViewCell\(indexPath.row)"
        return cell
    }
}

// MARK: - PlaceholderViewDelegate

extension RocketListViewController: PlaceholderViewDelegate {

    func onRetryTapped() {
        viewModel.retryTapped.send(())
    }
}
