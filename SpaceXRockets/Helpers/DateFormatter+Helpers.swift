//
//  DateFormatter+Helpers.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 5/6/21.
//

import Foundation

extension DateFormatter {
    
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let monthDayYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
}
