//
//  UIViewController+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

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
}
