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
/// + *white* title color
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
    convenience init(color: UIColor, title: String) {
        self.init(frame: .zero)

        set(color: color, title: title)
    }

    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .medium

        // constraints will be configured programmatically with AutoLayout:
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Sets base color and title for button configuration.
    /// - Parameters:
    ///   - color: A color for button background and foreground.
    ///   - title: A title text for button.
    ///   - systemImage: An `SFSymbol` image to place on the left of button title.
    final func set(color: UIColor, title: String, systemImage: UIImage? = nil) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = .white

        configuration?.title = title

        configuration?.image = systemImage
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}
