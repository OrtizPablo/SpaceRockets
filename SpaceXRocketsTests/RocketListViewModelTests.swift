//
//  RocketListViewModelTests.swift
//  SpaceXRocketsTests
//
//  Created by Pablo Ortiz Rodríguez on 31/5/21.
//

import XCTest
@testable import SpaceXRockets
import Combine

final class RocketListViewModelTests: XCTestCase {

    private var sutSpy: RocketListViewModelSpy!
    private var coordinator: MockRocketListCoordinator!
    
    func testDataRequestSuccessful() {
        _ = makeSUT(rocketRepository: MockRocketRepository())
        XCTAssertEqual(sutSpy.rockets.count, 2)
        XCTAssertEqual(sutSpy.rockets[0].name, "Falcon 1")
        XCTAssertEqual(sutSpy.rockets[1].name, "Falcon 2")
        XCTAssertFalse(sutSpy.isPlaceholderShown)
    }
    
    func testDataRequestFailure() {
        let rocketRepo = MockRocketRepository()
        rocketRepo.shouldFail = true
        _ = makeSUT(rocketRepository: rocketRepo)
        XCTAssertEqual(sutSpy.rockets.count, 0)
        XCTAssertTrue(sutSpy.isPlaceholderShown)
    }
    
    func testLoadingIndicatorIsShown() {
        _ = makeSUT(rocketRepository: MockRocketRepository())
        XCTAssertEqual(sutSpy.isLoadingValues.count, 2)
        XCTAssertTrue(sutSpy.isLoadingValues[0])
        XCTAssertFalse(sutSpy.isLoadingValues[1])
    }
    
    func testRetryData() {
        let rocketRepo = MockRocketRepository()
        rocketRepo.shouldFail = true
        let viewModel = makeSUT(rocketRepository: rocketRepo)
        XCTAssertEqual(sutSpy.rockets.count, 0)
        XCTAssertTrue(sutSpy.isPlaceholderShown)
        rocketRepo.shouldFail = false
        viewModel.retryTapped.send(())
        XCTAssertEqual(sutSpy.rockets.count, 2)
        XCTAssertFalse(sutSpy.isPlaceholderShown)
    }
    
    func testOnValidRocketTapped() {
       let viewModel = makeSUT(rocketRepository: MockRocketRepository())
       viewModel.rocketTapped.send(0)
       XCTAssertNotNil(coordinator.rocket)
    }
    
    func testOnInvalidRocketTapped() {
       let viewModel = makeSUT(rocketRepository: MockRocketRepository())
       viewModel.rocketTapped.send(2)
       XCTAssertNil(coordinator.rocket)
    }
}

// MARK: - Private helpers

extension RocketListViewModelTests {

    private func makeSUT(rocketRepository: RocketRepositoryProtocol) -> RocketListViewModel {
        sutSpy = RocketListViewModelSpy()
        coordinator = MockRocketListCoordinator()
        let sut = RocketListViewModel(coordinator: coordinator, rocketRepository: rocketRepository)
        sutSpy.attach(to: sut)
        sut.onViewReady()
        return sut
    }
}

// MARK: - RocketListViewModelSpy

private class RocketListViewModelSpy {
    
    var rockets = [Rocket]()
    var isLoadingValues = [Bool]()
    var isPlaceholderShown = false
    private var cancellables = Set<AnyCancellable>()
    
    func attach(to sut: RocketListViewModel) {
        sut.rockets
            .assign(to: \.rockets, on: self)
            .store(in: &cancellables)
            
        sut.isLoading.sink { [weak self] isLoading in
            self?.isLoadingValues.append(isLoading)
        }.store(in: &cancellables)
        
        sut.showPlaceholder
            .assign(to: \.isPlaceholderShown, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - MockRocketRepository

private class MockRocketRepository: RocketRepositoryProtocol {

    private let rocketsJson = """
        [
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
            },
            {
                "name": "Falcon 2",
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
        ]
    """
    
    private lazy var rockets: [Rocket]? = {
        guard let data = rocketsJson.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([Rocket].self, from: data)
    }()

    var shouldFail = false
    
    func getRockets(completion: @escaping((Result<[Rocket], NetworkError>) -> Void)) {
        if shouldFail {
            completion(.failure(.serverError))
        } else {
            if let rockets = rockets {
                completion(.success(rockets))
            }
        }
    }
}

// MARK: - MockRocketListCoordinator

private class MockRocketListCoordinator: RocketListCoordinatorProtocol {

    var rocket: Rocket?
    func onRocketTapped(_ rocket: Rocket) {
        self.rocket = rocket
    }
}
