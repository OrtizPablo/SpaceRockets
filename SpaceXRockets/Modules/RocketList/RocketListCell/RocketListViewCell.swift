//
//  RocketListCell.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 4/6/21.
//

import UIKit

final class RocketListViewCell: UITableViewCell {

    // MARK: - Properties
    
    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholderRocket")
        imageView.constraintToSize(CGSize(width: 40, height: 40))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var firstFlightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var activeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let upperStack = UIStackView(arrangedSubviews: [titleLabel, firstFlightLabel])
        upperStack.axis = .vertical
        upperStack.spacing = Constants.padding
        let vStack = UIStackView(arrangedSubviews: [upperStack, activeLabel])
        vStack.axis = .vertical
        vStack.spacing = Constants.halfPadding
        return vStack
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        stack.pin(to: container, topConstant: 0, trailingConstant: Constants.padding, bottomConstant: Constants.padding)
        placeholderImage.pin(to: container, leadingConstant: Constants.padding)
        NSLayoutConstraint.activate([
            placeholderImage.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: placeholderImage.trailingAnchor, constant: Constants.margin)
        ])
        return container
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    func setupCell(name: String, firstFlight: Date, active: Bool) {
        titleLabel.text = name
        firstFlightLabel.text = DateFormatter.monthDayYear.string(for: firstFlight)
        activeLabel.text = active ? "Active" : "Inactive"
        activeLabel.textColor = active ? .green : .red
    }
}
