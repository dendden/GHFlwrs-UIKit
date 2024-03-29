//
//  Constants.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

/// A collection of custom `UIImages` from `Asset Catalog`.
enum Images {

    static let ghLogo = UIImage(named: "gh-logo")
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
}

/// A collection of `UIImages` created with `SFSymbols`.
enum SystemImages {

    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let search = UIImage(systemName: "magnifyingglass")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
    static let bookmarkEmpty = UIImage(systemName: "bookmark")
    static let bookmarkFill = UIImage(systemName: "bookmark.fill")
    static let profile = UIImage(systemName: "person")
    static let profileFollowers = UIImage(systemName: "person.3")
}

/// Reference values for `width` and `height` of current `Window`.
///
/// Values are defined in `scene(willConnectTo:)` method of `SceneDelegate`.
enum ScreenSize {

    static var width: CGFloat = 0
    static var height: CGFloat = 0
}

/// A collection of smaller iPhone devices derived from ``ScreenSize`` height value.
enum DeviceTypes {

    static let idiom = UIDevice.current.userInterfaceIdiom
    static var nativeScale: CGFloat = 0
    static var scale: CGFloat = 0

    static let iPhone8      = idiom == .phone && ScreenSize.height == 667
    static let iPhone8Plus  = idiom == .phone && ScreenSize.height == 736
    static let iPhone13Mini = idiom == .phone && ScreenSize.height == 780
    static let iPhone11Pro  = idiom == .phone && ScreenSize.height == 812
}
