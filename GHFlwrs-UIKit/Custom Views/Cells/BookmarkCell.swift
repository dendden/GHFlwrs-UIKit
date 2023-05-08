//
//  BookmarkCell.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 04.05.2023.
//

import UIKit

/// A table cell displaying ``GFAvatarImageView`` and username of a
/// bookmarked user in horizontal alignment.
class BookmarkCell: UITableViewCell {

    static var reuseID = "BookmarkCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures cell label with follower's username and downloads avatar image.
    /// - Parameter bookmark: A user whose avatar and username
    /// must be displayed in cell.
    func set(bookmark: Follower) {
        usernameLabel.text = bookmark.login
        avatarImageView.downloadImage(fromURL: bookmark.avatarUrl)
    }

    /// Adds image and label subviews and lays out their constraints.
    private func configure() {
        contentView.addSubviews(avatarImageView, usernameLabel)

        accessoryType = .disclosureIndicator

        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
