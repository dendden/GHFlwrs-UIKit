//
//  UIViewController+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SafariServices
import UIKit

extension UIViewController {

    /// Presents custom ``GFAlertVC`` alert, dispatched on main thread.
    /// - Parameters:
    ///   - title: Alert title.
    ///   - message: A message that alert conveys.
    ///   - buttonTitle: A title for alert button. Default value is **"OK"**.
    ///   - completion: Optional completion handler to run when alert is dismissed.
    ///   Default value is **nil**.
    func presentGFAlert(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        haptic: UINotificationFeedbackGenerator.FeedbackType,
        completion: (() -> Void)? = nil
    ) {

        let alertVC = GFAlertVC(
            alertTitle: title,
            alertMessage: message,
            buttonTitle: buttonTitle,
            completion: completion
        )
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve

        UINotificationFeedbackGenerator().notificationOccurred(haptic)
        present(alertVC, animated: true)
    }

    /// Presents custom ``GFAlertVC`` alert, dispatched on main thread.
    /// - Parameters:
    ///   - title: Alert title.
    ///   - message: A message that alert conveys.
    ///   - buttonTitle: A title for alert button. Default value is **"OK"**.
    ///   - completion: Optional completion handler to run when alert is dismissed.
    ///   Default value is **nil**.
    func presentGenericError(
        completion: (() -> Void)? = nil
    ) {

        let alertVC = GFAlertVC(
            alertTitle: "Something went wrong",
            alertMessage: "An unexpected error came across our path, thy shall not fear and loose the faith!",
            buttonTitle: "Oi!",
            completion: completion
        )
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve

        UINotificationFeedbackGenerator().notificationOccurred(.error)
        present(alertVC, animated: true)
    }

    /// Displays a full-screen Safari ViewController with contents specified in URL.
    /// - Parameter url: An `url` to open in Safari Controller.
    ///
    /// Safari Controller is tinted in app's `.systemGreen` color by default.
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen

        present(safariVC, animated: true)
    }
}
