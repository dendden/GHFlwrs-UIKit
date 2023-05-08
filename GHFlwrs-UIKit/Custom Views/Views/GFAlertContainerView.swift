//
//  GFAlertContainerView.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 29.04.2023.
//

import UIKit

/// A container view for ``GFAlertVC`` content.
///
/// Default appearance includes:
/// + `.systemBackground` color
/// + `cornerRadius` of 16 pts
/// + `borderWidth` of 2 pts, `borderColor` of *white*.
class GFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor

        translatesAutoresizingMaskIntoConstraints = false
    }

}
