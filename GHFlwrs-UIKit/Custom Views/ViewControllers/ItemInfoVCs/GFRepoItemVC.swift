//
//  GFRepoItemVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

/// The delegate protocol for ViewControllers listening to action from
/// ``GFRepoItemVC`` action button.
protocol GFRepoItemVCDelegate: AnyObject {

    /// Informs the listening ViewController that a button was tapped
    /// requesting to open the provided `URL` string.
    /// - Parameter urlString: A string representation of `URL`
    /// that must be opened as a reaction to button tap.
    func didTapGitHubAccount(with urlString: String)
}

/// A concrete item info card class that presents the number of ``User``'s
/// public repos and gists and holds the action button that opens ``User``'s
/// profile page in a `SFSafariViewController`.
class GFRepoItemVC: GFItemInfoVC {

    /// A delegate `ViewController` that reacts to the tap of action button.
    weak var repoDelegate: GFRepoItemVCDelegate?

    /// Creates an instance of ``GFRepoItemVC``.
    /// - Parameters:
    ///   - user: A ``User``, whose repos, gists and profile link must
    ///   be displayed.
    ///   - delegate: A delegate listening to `actionButton` for opening
    ///   ``User``'s GitHub account in a `SFSafariViewController`.
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

    /// Configures the 2 ``GFItemInfoView``s with ``ItemInfoType/repos``
    /// and ``ItemInfoType/gists`` types and sets the title and color for
    /// `actionButton`.
    private func configureItems() {
        leftItemInfoView.setType(.repos, withCount: user.publicRepos)
        rightItemInfoView.setType(.gists, withCount: user.publicGists)

        actionButton.backgroundColor = .systemIndigo
        actionButton.setTitle("GitHub Profile", for: .normal)
    }

    /// Triggers the ``GFRepoItemVCDelegate``.``GFRepoItemVCDelegate/didTapGitHubAccount(with:)`` method.
    override func actionButtonTapped() {
        repoDelegate?.didTapGitHubAccount(with: user.htmlUrl)
    }
}
