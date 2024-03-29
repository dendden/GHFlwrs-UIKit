//
//  GFSubtitleLabel.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

/// A custom label configured for use with secondary title texts.
///
/// Label appearance includes:
/// + **medium** font weight
/// + **.secondaryLabel** font color
/// + **truncating tail** line break mode
/// + **0.85** min scale factor.
class GFSubtitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates an instance of ``GFSubtitleLabel``.
    /// - Parameters:
    ///   - fontSize: Font size for label text.
    ///   - textAlignment: Alignment for the label text. Default value is **.left**.
    convenience init(fontSize: CGFloat, textAlignment: NSTextAlignment = .left) {
        self.init(frame: .zero)

        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }

    private func configure() {
        // num of lines will get configured when this label is called
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.85
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
