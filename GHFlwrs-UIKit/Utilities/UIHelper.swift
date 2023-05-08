//
//  UIHelper.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 01.05.2023.
//

import UIKit

enum UIHelper {

    /// Creates a 3-column `FlowLayout` within the bounds of given view.
    /// - Parameters:
    ///   - view: A view that hosts the `CollectionView` and defines its bounds.
    ///   - padding: Distance from `CollectionView` to all edges of `UIEdgeInsets`.
    ///   - minItemSpacing: Minimum spacing between `CollectionView` cells.
    /// - Returns: A 3-column `FlowLayout` for a `UICollectionView`.
    ///
    /// Default parameter values are:
    /// + *padding*: 12
    /// + *minItemSpacing*: 10
    static func makeThreeColumnFlowLayout(
        in view: UIView,
        padding: CGFloat = 12,
        minItemSpacing: CGFloat = 10
    ) -> UICollectionViewFlowLayout {

        let totalWidth = view.bounds.width
        let usefulWidth = totalWidth - (padding * 2) - (minItemSpacing * 2)
        let itemWidth = usefulWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
}
