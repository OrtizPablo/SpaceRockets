//
//  RocketDetailsViewModelTests.swift
//  SpaceXRocketsTests
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

import XCTest
@testable import SpaceXRockets
import Combine

final class RocketDetailsViewModelTests: XCTestCase {

    private var sutSpy: RocketDetailsViewModelSpy!

    private let rocket1Json = """
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
            "active": false
        }
    """
    
    private lazy var rocket1: Rocket? = {
        guard let data = rocket1Json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Rocket.self, from: data)
    }()
    
    private let rocket2Json = """
        {
            "name": "Falcon 9",
            "description": "Falcon 9 is a two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.",
            "flickr_images": [
                "https://farm1.staticflickr.com/929/28787338307_3453a11a77_b.jpg"
            ],
            "first_flight": "2010-06-04",
            "cost_per_launch": 50000000,
            "success_rate_pct": 98,
            "country": "United States",
            "company": "SpaceX",
            "active": true
        }
    """
    
    private lazy var rocket2: Rocket? = {
        guard let data = rocket2Json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Rocket.self, from: data)
    }()

    func testViewModelOutputsInactiveRocket() {
        guard let rocket = rocket1 else {
            XCTFail("Unable to create model")
            return
        }
        let viewModel = makeSUT(rocket: rocket)
        XCTAssertEqual(viewModel.navTitle, "Falcon 1")
        XCTAssertEqual(viewModel.cellsInfo.count, 6)
        XCTAssertEqual(viewModel.cellsInfo[0].title, "Description")
        XCTAssertEqual(viewModel.cellsInfo[0].description, "The Falcon 1 was an expendable launch system privately developed and manufactured by SpaceX during 2006-2009. On 28 September 2008, Falcon 1 became the first privately-developed liquid-fuel launch vehicle to go into orbit around the Earth.")
        XCTAssertEqual(viewModel.cellsInfo[1].title, "First Flight")
        XCTAssertEqual(viewModel.cellsInfo[1].description, "Mar 24, 2006")
        XCTAssertEqual(viewModel.cellsInfo[2].title, "Cost Per Launch")
        XCTAssertEqual(viewModel.cellsInfo[2].description, "£6700000")
        XCTAssertEqual(viewModel.cellsInfo[3].title, "Success Rate")
        XCTAssertEqual(viewModel.cellsInfo[3].description, "40%")
        XCTAssertEqual(viewModel.cellsInfo[4].title, "Company")
        XCTAssertEqual(viewModel.cellsInfo[4].description, "SpaceX")
        XCTAssertEqual(viewModel.cellsInfo[5].title, "Country")
        XCTAssertEqual(viewModel.cellsInfo[5].description, "Republic of the Marshall Islands")
        XCTAssertEqual(viewModel.imageBorderColor, .red)
    }
    
    func testViewModelOutputsActiveRocket() {
        guard let rocket = rocket2 else {
            XCTFail("Unable to create model")
            return
        }
        let viewModel = makeSUT(rocket: rocket)
        XCTAssertEqual(viewModel.navTitle, "Falcon 9")
        XCTAssertEqual(viewModel.cellsInfo.count, 6)
        XCTAssertEqual(viewModel.cellsInfo[0].title, "Description")
        XCTAssertEqual(viewModel.cellsInfo[0].description, "Falcon 9 is a two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.")
        XCTAssertEqual(viewModel.cellsInfo[1].title, "First Flight")
        XCTAssertEqual(viewModel.cellsInfo[1].description, "Jun 4, 2010")
        XCTAssertEqual(viewModel.cellsInfo[2].title, "Cost Per Launch")
        XCTAssertEqual(viewModel.cellsInfo[2].description, "£50000000")
        XCTAssertEqual(viewModel.cellsInfo[3].title, "Success Rate")
        XCTAssertEqual(viewModel.cellsInfo[3].description, "98%")
        XCTAssertEqual(viewModel.cellsInfo[4].title, "Company")
        XCTAssertEqual(viewModel.cellsInfo[4].description, "SpaceX")
        XCTAssertEqual(viewModel.cellsInfo[5].title, "Country")
        XCTAssertEqual(viewModel.cellsInfo[5].description, "United States")
        XCTAssertEqual(viewModel.imageBorderColor, .green)
    }
    
    func testFetchImageSucceeds() {
        guard let rocket = rocket1 else {
            XCTFail("Unable to create model")
            return
        }
        _ = makeSUT(rocket: rocket)
        XCTAssertNotNil(sutSpy.image)
        XCTAssertEqual(sutSpy.image, UIImage(named: "placeholderError"))
    }
    
    func testFetchImageFails() {
        guard let rocket = rocket1 else {
            XCTFail("Unable to create model")
            return
        }
        _ = makeSUT(rocket: rocket, imageRepository: MockFailureImageRepository())
        XCTAssertNotNil(sutSpy.image)
        XCTAssertEqual(sutSpy.image, UIImage(named: "placeholderRocket"))
    }
}

// MARK: - Private helpers

extension RocketDetailsViewModelTests {

    private func makeSUT(rocket: Rocket, imageRepository: ImageRepositoryProtocol = MockSuccessfulImageRepository()) -> RocketDetailsViewModel {
        sutSpy = RocketDetailsViewModelSpy()
        let sut = RocketDetailsViewModel(rocket: rocket, imageRepository: imageRepository)
        sutSpy.attach(to: sut)
        return sut
    }
}

// MARK: - RocketDetailsViewModelSpy

final class RocketDetailsViewModelSpy {

    var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    func attach(to sut: RocketDetailsViewModel) {
        sut.image.sink { [weak self] image in
            self?.image = image
        }.store(in: &cancellables)
    }
}

// MARK: - MockSuccessfulImageRepository

final class MockSuccessfulImageRepository: ImageRepositoryProtocol {

    func fetchImage(url: URL, onSuccess: @escaping ((UIImage?) -> Void)) {
        onSuccess(UIImage(named: "placeholderError"))
    }
}

// MARK: - MockFailureImageRepository

final class MockFailureImageRepository: ImageRepositoryProtocol {
    func fetchImage(url: URL, onSuccess: @escaping ((UIImage?) -> Void)) {}
}
