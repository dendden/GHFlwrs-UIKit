//
//  GFRepoItemVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubAccount(with urlString: String)
}

class GFRepoItemVC: GFItemInfoVC {

    weak var repoDelegate: GFRepoItemVCDelegate?

    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)

        repoDelegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        repoDelegate?.didTapGitHubAccount(with: user.htmlUrl)
    }
}
