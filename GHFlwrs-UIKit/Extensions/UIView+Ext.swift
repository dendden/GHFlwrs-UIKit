//
//  UIView+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 05.05.2023.
//

import UIKit

extension UIView {

    /// Adds multiple subviews to this view.
    /// - Parameter views: A variadic collection of subviews to add.
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }

    /// Activates constraints aligning all 4 edges of this view to provided superview.
    /// - Parameter superview: A superview, to which this view must be pinned.
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
