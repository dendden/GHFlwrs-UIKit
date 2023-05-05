//
//  UIView+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 05.05.2023.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
