//
//  GFSearchField.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

/// A style Github Followers Text Field.
///
/// Default modifiers include:
/// + **Font**: '.title2', lineLimit: 1, min. font size: 12, text alignment: '.center'
/// + autocorrection disabled
/// + cursor tint and text color set to `.label`
/// + background color of `tertiarySystemBackground`
/// + border color of `systemGray4`, border width of 2
/// + corner radius of 10
class GFSearchField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor

        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no

        let searchImage = UIImage(systemName: "magnifyingglass")!
        let placeholderString = NSMutableAttributedString()
        placeholderString.append(NSAttributedString(attachment: NSTextAttachment(image: searchImage)))
        placeholderString.append(NSAttributedString(string: " Search username"))

        attributedPlaceholder = placeholderString
    }
}
