//
//  GFTitleLabel.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

/// A custom label configured for use with title texts.
///
/// Label appearance includes:
/// + **bold** font weight
/// + **.label** font color
/// + **truncating tail** line break mode
/// + **0.85** min scale factor.
class GFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates an instance of ``GFTitleLabel``.
    /// - Parameters:
    ///   - textAlignment: Alignment for the label text.
    ///   - fontSize: Font size for label text.
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)

        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    private func configure() {
        // num of lines will get configured when this label is called
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.85
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
