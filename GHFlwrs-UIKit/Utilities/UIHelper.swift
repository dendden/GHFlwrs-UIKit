//
//  UIHelper.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 01.05.2023.
//

import UIKit

struct UIHelper {

    static func makeThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let totalWidth = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat = 10
        let usefulWidth = totalWidth - (padding * 2) - (minItemSpacing * 2)
        let itemWidth = usefulWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
}
