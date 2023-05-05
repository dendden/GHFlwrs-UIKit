//
//  GFUserInfoHeaderVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSubtitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GFSubtitleLabel(fontSize: 18)
    let bioLabel = GFBodyLabel(textAlignment: .left)

    var user: User!

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews(avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel)
        layoutUI()
        configureUIElements()
    }

    private func configureUIElements() {

        avatarImageView.downloadImage(from: user.avatarUrl)
        usernameLabel.text          = user.login
        nameLabel.text              = user.name ?? ""
        bioLabel.text               = user.bio ?? "*No bio available.*"
        bioLabel.numberOfLines      = 3
        locationLabel.text = user.location ?? "*n/a*"
        locationImageView.image     = SystemImages.location
        locationImageView.tintColor = .secondaryLabel
    }

    private func layoutUI() {
        let textToImagePadding: CGFloat = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: textToImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 0.4),

            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: textToImagePadding),
            locationImageView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 0.22),
            locationImageView.widthAnchor.constraint(equalTo: locationImageView.heightAnchor),

            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(
                equalTo: locationImageView.trailingAnchor,
                constant: textToImagePadding / 2),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 0.22),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textToImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -textToImagePadding / 2),
            nameLabel.heightAnchor.constraint(equalTo: locationLabel.heightAnchor),

            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textToImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 0.7)
        ])
    }

}
