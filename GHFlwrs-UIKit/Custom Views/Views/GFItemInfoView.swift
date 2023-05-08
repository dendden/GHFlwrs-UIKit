//
//  GFItemInfoView.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

/// A selection of available types of ``User`` parameters that can be
/// displayed by ``GFItemInfoView``.
enum ItemInfoType {
    case repos, gists, followers, following
}

/// A custom view illustrating certain ``User`` parameter within
/// ``GFItemInfoVC`` card view.
///
/// This view includes an `SFSymbol` image and title label on top
/// and count label centered beneath.
class GFItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures ``symbolImageView`` and lays out constraints for all subview elements.
    private func configure() {
        addSubviews(symbolImageView, titleLabel, countLabel)

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

    /// Sets the type of ``User`` parameter to display.
    /// - Parameters:
    ///   - infoType: A type that defines contents of ``symbolImageView``
    ///   and ``titleLabel``.
    ///   - count: The count of parameter to display in ``countLabel``.
    func setType(_ infoType: ItemInfoType, withCount count: Int) {
        switch infoType {
        case .repos:
            symbolImageView.image = SystemImages.repos
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImageView.image = SystemImages.gists
            titleLabel.text = "Public Gists"
        case .followers:
            symbolImageView.image = SystemImages.followers
            titleLabel.text = "Followers"
        case .following:
            symbolImageView.image = SystemImages.following
            titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }

}
