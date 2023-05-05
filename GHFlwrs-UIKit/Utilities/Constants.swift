//
//  Constants.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

enum Images {
    static let ghLogo = UIImage(named: "gh-logo")
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
}

enum SystemImages {
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let search = UIImage(systemName: "magnifyingglass")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
    static let bookmarkEmpty = UIImage(systemName: "bookmark")
    static let bookmarkFill = UIImage(systemName: "bookmark.fill")
}

enum ScreenSize {
    static var width: CGFloat = 0
    static var height: CGFloat = 0
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static var nativeScale: CGFloat = 0
    static var scale: CGFloat = 0

    static let iPhone8      = idiom == .phone && ScreenSize.height == 667
    static let iPhone8Plus  = idiom == .phone && ScreenSize.height == 736
    static let iPhone13Mini = idiom == .phone && ScreenSize.height == 780
    static let iPhone11Pro  = idiom == .phone && ScreenSize.height == 812
}
