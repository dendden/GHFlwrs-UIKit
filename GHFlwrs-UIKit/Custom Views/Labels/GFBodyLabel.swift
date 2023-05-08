//
//  GFBodyLabel.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

/// A custom label configured for use with plain body texts.
///
/// Label appearance includes:
/// + **body** font style
/// + **.secondaryLabel** font color
/// + **word wrapping** line break mode
/// + **0.75** min scale factor.
class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates an instance of ``GFBodyLabel``.
    /// - Parameter textAlignment: Alignment for the label text.
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)

        self.textAlignment = textAlignment
    }

    private func configure() {
        // num of lines will get configured when this label is called
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
