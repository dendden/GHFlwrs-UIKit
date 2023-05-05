//
//  GFButton.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

/// A styled Github Followers button.
///
/// Default modifiers include:
/// + *white* text color
/// + *.headline* text font
/// + corner radius of 10
class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    // Storyboard initializer:
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Initializes `GFButton` with given background color and
    /// title.
    /// - Parameters:
    ///   - buttonColor: A background color for `GFButton`.
    ///   - title: A title for `GFButton`.
    convenience init(buttonColor: UIColor, title: String) {
        self.init(frame: .zero)

        self.backgroundColor = buttonColor
        self.setTitle(title, for: .normal)
    }

    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        // constraints will be configured programmatically with AutoLayout:
        translatesAutoresizingMaskIntoConstraints = false
    }

}
