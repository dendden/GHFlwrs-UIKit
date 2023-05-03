//
//  GFFollowerItemVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {

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

}
