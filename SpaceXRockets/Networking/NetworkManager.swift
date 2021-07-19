//
//  NetworkManager.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 31/5/21.
//

import UIKit

enum NetworkError: Error {
    case clientError
    case serverError
    case parsingError
    case unknownError
}

protocol NetworkManagerProtocol {
    func requestData<T: Decodable>(url: URL, completion: @escaping(Result<[T], NetworkError>) -> Void)
    func fetchImage(url: URL, onSuccess: @escaping((UIImage?) -> Void))
}

final class NetworkManager: NetworkManagerProtocol {

    func requestData<T: Decodable>(url: URL, completion: @escaping(Result<[T], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.clientError))
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            do {
                let entities = try JSONDecoder().decode([T].self, from: data)
                completion(.success(entities))
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
    }
    
    func fetchImage(url: URL, onSuccess: @escaping((UIImage?) -> Void)) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            onSuccess(UIImage(data: data))
        }.resume()
    }
}
