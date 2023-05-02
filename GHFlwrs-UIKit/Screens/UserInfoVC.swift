//
//  UserInfoVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

class UserInfoVC: UIViewController {

    var user: Follower!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = user.login
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }

}
