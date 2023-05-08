//
//  FollowerCell.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import UIKit

/// A collection cell displaying follower's ``GFAvatarImageView`` and username
/// in vertical alignment.
class FollowerCell: UICollectionViewCell {

    static var reuseID = "FollowerCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures cell label with follower's username and downloads avatar image.
    /// - Parameter follower: A follower whose avatar and username
    /// must be displayed in cell.
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(fromURL: follower.avatarUrl)
    }

    /// Adds image and label subviews and lays out their constraints.
    private func configure() {
        contentView.addSubviews(avatarImageView, usernameLabel)

        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
