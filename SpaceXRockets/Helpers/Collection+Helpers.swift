//
//  Collection+Helpers.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
