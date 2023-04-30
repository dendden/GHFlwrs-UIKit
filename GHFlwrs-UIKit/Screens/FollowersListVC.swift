//
//  FollowersListVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

class FollowersListVC: UIViewController {

    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        NetworkManager.shared.getFollowers(for: username, page: 1) { result in

            switch result {
            case .success(let followers):
                print(">>> Found \(followers.count) followers:")
                for follower in followers {
                    print(">>> \(follower)")
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Problem 🤦🏼‍♂️", message: error.rawValue)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
