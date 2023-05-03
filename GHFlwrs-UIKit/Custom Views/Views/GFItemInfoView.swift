//
//  GFItemInfoView.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class GFItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

    var childViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        childViews = [symbolImageView, titleLabel, countLabel]

        for child in childViews {
            addSubview(child)
        }

        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label  // tint is blue by default

        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),

            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func setType(_ infoType: ItemInfoType, withCount count: Int) {
        switch infoType {
        case .repos:
            symbolImageView.image = UIImage(systemName: "folder")
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImageView.image = UIImage(systemName: "text.alignleft")
            titleLabel.text = "Public Gists"
        case .followers:
            symbolImageView.image = UIImage(systemName: "heart")
            titleLabel.text = "Followers"
        case .following:
            symbolImageView.image = UIImage(systemName: "person.2")
            titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }

}