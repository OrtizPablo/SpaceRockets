//
//  BaseViewController.swift
//  SpaceXRockets
//
//  Created by Pablo Ortiz Rodríguez on 1/6/21.
//

import UIKit
import Combine

class BaseViewController: UIViewController {

    // MARK: - Properties
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private(set) var placeholderView = PlaceholderView()
    
    internal var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayLight
    }
    
    // MARK: - Functions

    func showLoadingIndicator() {
        loadingIndicator.color = .red
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
    }

    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    func showPlaceholder() {
        view.addSubview(placeholderView)
        placeholderView.pin(to: view)
        view.bringSubviewToFront(placeholderView)
    }
    
    func hidePlaceholder() {
        placeholderView.removeFromSuperview()
    }
}
