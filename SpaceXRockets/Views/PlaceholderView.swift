//
//  PlaceholderView.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 2/6/21.
//

import UIKit

protocol PlaceholderViewDelegate: AnyObject {
    func onRetryTapped()
}

final class PlaceholderView: UIView {

    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "placeholderError")
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong, please try again"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(onRetryTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: PlaceholderViewDelegate?
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private helpers

extension PlaceholderView {

    private func setupView() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(retryButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.margin),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.margin),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.margin),
            retryButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.margin),
            retryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.margin),
            retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.margin),
        ])
    }
    
    @objc private func onRetryTapped() {
        delegate?.onRetryTapped()
    }
}
