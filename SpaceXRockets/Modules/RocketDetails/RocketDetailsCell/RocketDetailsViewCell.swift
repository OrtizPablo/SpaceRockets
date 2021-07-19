//
//  RocketDetailsViewCell.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 3/6/21.
//

import UIKit

final class RocketDetailsViewCell: UITableViewCell {

    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, UIView()])
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        stack.axis = .vertical
        return stack
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [horizontalStack, descriptionLabel])
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        stack.axis = .horizontal
        stack.spacing = Constants.margin
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stackView.pin(to: self, leadingConstant: Constants.margin, topConstant: Constants.padding, trailingConstant: Constants.margin, bottomConstant: Constants.padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setupCell(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
