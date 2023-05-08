//
//  GFDataLoadingVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 05.05.2023.
//

import UIKit

/// A superclass for view controllers that perform networking requests and thus
/// may need to display a loading progress animation.
class GFDataLoadingVC: UIViewController {

    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Shows loading view as a transparent screen pinned to view's bounds
    /// and a large activity indicator in the center.
    ///
    /// Loading progress view appearance is animated with alpha component.
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

    /// Removes the progress loading view from its superview on **main thread**.
    func dismissLoadingProgressView() {
        // Always gets called from background threads - so dispatch to main
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }

    /// Adds an ``GFEmptyStateView`` to the top of view hierarchy, pinned
    /// to view's bounds.
    /// - Parameters:
    ///   - message: A text to display in the body of ``GFEmptyStateView``.
    ///   - view: The view that hosts the ``GFEmptyStateView``.
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
