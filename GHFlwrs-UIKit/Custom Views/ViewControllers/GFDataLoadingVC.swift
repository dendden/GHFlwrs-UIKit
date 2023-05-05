//
//  GFDataLoadingVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 05.05.2023.
//

import UIKit

class GFDataLoadingVC: UIViewController {

    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showLoadingProgressView() {
        containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        view.addSubview(containerView)

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingProgressView() {
        // Always gets called from background threads - so dispatch to main
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }

    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
