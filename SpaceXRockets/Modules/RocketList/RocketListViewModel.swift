//
//  RocketListViewModel.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 1/6/21.
//

import Foundation
import Combine

protocol RocketListCoordinatorProtocol: AnyObject {
    func onRocketTapped(_ rocket: Rocket)
}

protocol RocketListViewModelProtocol {
    var rockets: CurrentValueSubject<[Rocket], Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var showPlaceholder: AnyPublisher<Bool, Never> { get }
    var retryTapped: PassthroughSubject<Void, Never> { get }
    var rocketTapped: PassthroughSubject<Int, Never> { get }
    func onViewReady()
}

final class RocketListViewModel: RocketListViewModelProtocol {

    // MARK: - Properties
    
    private let rocketRepository: RocketRepositoryProtocol
  
    var rockets = CurrentValueSubject<[Rocket], Never>([])
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    var isLoading: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    private let showPlaceholderSubject = PassthroughSubject<Bool, Never>()
    var showPlaceholder: AnyPublisher<Bool, Never> {
        showPlaceholderSubject.eraseToAnyPublisher()
    }
    let retryTapped = PassthroughSubject<Void, Never>()
    let rocketTapped = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private weak var coordinator: RocketListCoordinatorProtocol?
    
    // MARK: - Initialization
    
    init(coordinator: RocketListCoordinatorProtocol?,
         rocketRepository: RocketRepositoryProtocol = RocketRepository()) {
        self.coordinator = coordinator
        self.rocketRepository = rocketRepository
        bindings()
    }
    
    // MARK: - Public functions
    
    func onViewReady() {
        loadData()
    }
}

// MARK: - Private helpers

extension RocketListViewModel {

    private func loadData() {
        isLoadingSubject.send(true)
        rocketRepository.getRockets { [weak self] result in
            self?.isLoadingSubject.send(false)
            switch result {
            case .success(let rockets):
                self?.rockets.value = rockets
            case .failure:
                self?.showPlaceholderSubject.send(true)
            }
        }
    }
}

// MARK: - Bindings

extension RocketListViewModel {

    private func bindings() {
        retryTapped.sink { [weak self] in
            self?.showPlaceholderSubject.send(false)
            self?.loadData()
        }.store(in: &cancellables)
        
        rocketTapped.sink { [weak self] index in
            guard let rocket = self?.rockets.value[safe: index] else { return }
            self?.coordinator?.onRocketTapped(rocket)
        }.store(in: &cancellables)
    }
}
