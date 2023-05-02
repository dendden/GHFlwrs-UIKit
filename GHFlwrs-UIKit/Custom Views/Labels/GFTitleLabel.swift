//
//  GFTitleLabel.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

class GFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)

        configure()
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
