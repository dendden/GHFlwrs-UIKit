//
//  UIViewController+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

private var containerView: UIView!

extension UIViewController {

    func presentGFAlertOnMainThread(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {

        DispatchQueue.main.async {
            let alertVC = GFAlertVC(
                alertTitle: title,
                alertMessage: message,
                buttonTitle: buttonTitle,
                completion: completion
            )
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve

            self.present(alertVC, animated: true)
        }
    }

    func showLoadingProgressView() {
        containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        view.addSubview(containerView)

        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingProgressView() {
        // Always gets called from background threads - so dispatch to main
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }

    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
