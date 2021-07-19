//
//  MainCoordinatorTests.swift
//  SpaceXRocketsTests
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

import XCTest
@testable import SpaceXRockets

final class MainCoordinatorTests: XCTestCase {

    private let rocketJson = """
        {
            "name": "Falcon 1",
            "description": "The Falcon 1 was an expendable launch system privately developed and manufactured by SpaceX during 2006-2009. On 28 September 2008, Falcon 1 became the first privately-developed liquid-fuel launch vehicle to go into orbit around the Earth.",
            "flickr_images": [
                "https://imgur.com/DaCfMsj.jpg",
                "https://imgur.com/azYafd8.jpg"
            ],
            "first_flight": "2006-03-24",
            "cost_per_launch": 6700000,
            "success_rate_pct": 40,
            "country": "Republic of the Marshall Islands",
            "company": "SpaceX",
            "active": true
        }
    """
    
    private lazy var rocket: Rocket? = {
        guard let data = rocketJson.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Rocket.self, from: data)
    }()

    func testDetailsScreenIsPushedWhenRocketTappedFromList() {
        guard let rocket = rocket else {
            XCTFail("Unable to create rocket")
            return
        }
        let mockNavigator = UINavigationController()
        let coordinator = MainCoordinator(navigationController: mockNavigator)
        coordinator.onRocketTapped(rocket)
        XCTAssertTrue(mockNavigator.topViewController is RocketDetailsViewController)
    }
}
