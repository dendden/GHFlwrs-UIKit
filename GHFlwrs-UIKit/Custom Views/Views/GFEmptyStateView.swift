//
//  GFEmptyStateView.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 01.05.2023.
//

import UIKit

/// A `UIView` displayed by ``GFDataLoadingVC`` controllers when their
/// data sources are empty.
///
/// Shows a message in top left and an ``Images/emptyStateLogo`` image
/// in bottom right.
class GFEmptyStateView: UIView {

    /// A text displayed in view's body.
    ///
    /// Default label appearance includes:
    /// + text alignment is **.left**, font size is **28**
    /// + **.secondaryLabel** text color
    /// + 3 lines of text limit.
    let messageLabel = GFTitleLabel(textAlignment: .left, fontSize: 28)

    /// An ``Images/emptyStateLogo`` image displayed in
    /// bottom right corner of the view.
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///  Creates an instance of ``GFEmptyStateView``.
    /// - Parameter message: A text to display in view's body.
    convenience init(message: String) {
        self.init(frame: .zero)

        messageLabel.text = message
    }

    private func configure() {
        addSubviews(messageLabel, logoImageView)

        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel

        logoImageView.image = Images.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -35),
            messageLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }
}
