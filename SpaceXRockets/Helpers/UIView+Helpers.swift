//
//  UIView+Helpers.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 31/5/21.
//

import UIKit

extension UIView {

    func pin(to view: UIView, leadingConstant: CGFloat? = nil, topConstant: CGFloat? = nil, trailingConstant: CGFloat? = nil, bottomConstant: CGFloat? = nil) {
        var constraints = [NSLayoutConstraint]()
        if let leadingConstant = leadingConstant {
            constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant))
        }
        if let topConstant = topConstant {
            constraints.append(topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: topConstant))
        }
        if let trailingConstant = trailingConstant {
            constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingConstant))
        }
        if let bottomConstant = bottomConstant {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomConstant))
        }
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    func pin(to view: UIView, padding: CGFloat = 0) {
        pin(to: view, leadingConstant: padding, topConstant: padding, trailingConstant: padding, bottomConstant: padding)
    }
    
    func pinToTopAndSides(to view: UIView, height: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    func constraintToSize(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
        ])
    }
    
    func center(to view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
