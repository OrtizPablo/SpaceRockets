//
//  RocketDetailsViewModel.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

import Foundation
import UIKit
import Combine

struct RocketDetailsCellInfo {
    let title: String
    let description: String
}

protocol RocketDetailsViewModelProtocol {
    var navTitle: String { get }
    var image: CurrentValueSubject<UIImage?, Never> { get }
    var imageBorderColor: UIColor { get }
    var cellsInfo: [RocketDetailsCellInfo] { get }
}

final class RocketDetailsViewModel: RocketDetailsViewModelProtocol {

    // MARK: - Properties
    
    private let imageRepository: ImageRepositoryProtocol
    
    var navTitle: String { return rocket.name }
    let image = CurrentValueSubject<UIImage?, Never>(UIImage(named: "placeholderRocket"))
    var imageBorderColor: UIColor { return rocket.active ? .green : .red }
    var cellsInfo: [RocketDetailsCellInfo]
    private let rocket: Rocket
    
    // MARK: - Initialization
    
    init(rocket: Rocket,
         imageRepository: ImageRepositoryProtocol = ImageRepository()) {
        self.imageRepository = imageRepository
        self.rocket = rocket
        cellsInfo = [
            RocketDetailsCellInfo(title: "Description", description: rocket.description),
            RocketDetailsCellInfo(title: "First Flight", description: DateFormatter.monthDayYear.string(from: rocket.firstFlight)),
            RocketDetailsCellInfo(title: "Cost Per Launch", description: "£" + String(rocket.costPerLaunch)),
            RocketDetailsCellInfo(title: "Success Rate", description: String(rocket.successRate) + "%"),
            RocketDetailsCellInfo(title: "Company", description: rocket.company),
            RocketDetailsCellInfo(title: "Country", description: rocket.country)
        ]
        loadImage()
    }
}

// MARK: - Private helpers

extension RocketDetailsViewModel {

    private func loadImage() {
        guard let imagePath = rocket.imagePath, let url = URL(string: imagePath) else { return }
        imageRepository.fetchImage(url: url) { [weak self] image in
            self?.image.value = image
        }
    }
}
