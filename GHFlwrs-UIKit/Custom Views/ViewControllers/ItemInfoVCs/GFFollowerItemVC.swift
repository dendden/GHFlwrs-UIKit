//
//  GFFollowerItemVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(hasFollowers: Bool)
}

class GFFollowerItemVC: GFItemInfoVC {

    weak var followerDelegate: GFFollowerItemVCDelegate?

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

    private func configureItems() {
        leftItemInfoView.setType(.followers, withCount: user.followers)
        rightItemInfoView.setType(.following, withCount: user.following)

        actionButton.backgroundColor = .systemGreen
        actionButton.setTitle("Get Followers", for: .normal)
    }

    override func actionButtonTapped() {
        followerDelegate?.didTapGetFollowers(hasFollowers: user.followers > 0)
    }

}
