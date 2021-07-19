//
//  Rocket.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 1/6/21.
//

import Foundation

struct Rocket: Decodable {
    let name: String
    let description: String
    let imagePath: String?
    let firstFlight: Date
    let costPerLaunch: Int
    let successRate: Int
    let country: String
    let company: String
    let active: Bool
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case imagePath = "flickr_images"
        case firstFlight = "first_flight"
        case costPerLaunch = "cost_per_launch"
        case successRate = "success_rate_pct"
        case country
        case company
        case active
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        imagePath = try container.decode([String].self, forKey: .imagePath).first
        let firstFlightDate = try container.decode(String.self, forKey: .firstFlight)
        firstFlight = DateFormatter.yearMonthDay.date(from: firstFlightDate) ?? Date()
        costPerLaunch = try container.decode(Int.self, forKey: .costPerLaunch)
        successRate = try container.decode(Int.self, forKey: .successRate)
        country = try container.decode(String.self, forKey: .country)
        company = try container.decode(String.self, forKey: .company)
        active = try container.decode(Bool.self, forKey: .active)
    }
}
