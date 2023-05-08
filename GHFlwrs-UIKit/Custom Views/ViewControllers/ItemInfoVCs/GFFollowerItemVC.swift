//
//  GFFollowerItemVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

/// The delegate protocol for ViewControllers listening to action from
/// ``GFFollowerItemVC`` action button.
protocol GFFollowerItemVCDelegate: AnyObject {

    /// Informs the listening ViewController that a button was tapped
    /// requesting to list user's followers.
    /// - Parameter hasFollowers: Tells the listening ViewController
    /// whether a followers list or 'no followers' alert must be shown.
    func didTapGetFollowers(hasFollowers: Bool)
}

/// A concrete item info card class that presents the number of ``User``'s
/// followers and followed users and holds the action button that lists ``User``'s
/// followers in ``FollowersListVC``.
class GFFollowerItemVC: GFItemInfoVC {

    /// A delegate `ViewController` that reacts to the tap of action button.
    weak var followerDelegate: GFFollowerItemVCDelegate?

    /// Creates an instance of ``GFFollowerItemVC``.
    /// - Parameters:
    ///   - user: A ``User``, whose number of followers and followed users
    ///   must be displayed.
    ///   - delegate: A delegate listening to `actionButton` for listing
    ///   user's followers or displaying a 'no followers' alert.
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)

        followerDelegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }

    /// Configures the 2 ``GFItemInfoView``s with ``ItemInfoType/followers``
    /// and ``ItemInfoType/following`` types and sets the title and color for
    /// `actionButton`.
    private func configureItems() {
        leftItemInfoView.setType(.followers, withCount: user.followers)
        rightItemInfoView.setType(.following, withCount: user.following)

        actionButton.backgroundColor = .systemGreen
        actionButton.setTitle("Get Followers", for: .normal)
    }

    /// Triggers the ``GFFollowerItemVCDelegate``.
    /// ``GFFollowerItemVCDelegate/didTapGetFollowers(hasFollowers:)`` method.
    override func actionButtonTapped() {
        followerDelegate?.didTapGetFollowers(hasFollowers: user.followers > 0)
    }

}
