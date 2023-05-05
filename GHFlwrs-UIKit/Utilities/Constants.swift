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
