//
//  GFRepoItemVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }

    private func configureItems() {
        leftItemInfoView.setType(.repos, withCount: user.publicRepos)
        rightItemInfoView.setType(.gists, withCount: user.publicGists)

        actionButton.backgroundColor = .systemIndigo
        actionButton.setTitle("GitHub Profile", for: .normal)
    }

    override func actionButtonTapped() {
        userInfoDelegate?.didTapGitHubAccount(with: user.htmlUrl)
    }
}
