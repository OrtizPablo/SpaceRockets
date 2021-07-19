//
//  RocketsRepository.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 31/5/21.
//
import UIKit

protocol RocketRepositoryProtocol {
    func getRockets(completion: @escaping((Result<[Rocket], NetworkError>) -> Void))
}

final class RocketRepository: RocketRepositoryProtocol {

    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getRockets(completion: @escaping ((Result<[Rocket], NetworkError>) -> Void)) {
        guard let url = URL(string: "https://api.spacexdata.com/v4/rockets") else { return }
        networkManager.requestData(url: url) { (result: Result<[Rocket], NetworkError>) in
            switch result {
            case .success(let rockets): completion(.success(rockets))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
