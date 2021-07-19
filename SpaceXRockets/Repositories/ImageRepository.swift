//
//  ImageRepository.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 5/6/21.
//

import UIKit

protocol ImageRepositoryProtocol {
    func fetchImage(url: URL, onSuccess: @escaping((UIImage?) -> Void))
}

final class ImageRepository: ImageRepositoryProtocol {

    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchImage(url: URL, onSuccess: @escaping((UIImage?) -> Void)) {
        networkManager.fetchImage(url: url) { image in
            onSuccess(image)
        }
    }
}
