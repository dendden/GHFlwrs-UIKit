//
//  Follower.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

struct Follower: Codable {

    var login: String
    var avatarUrl: String   // will be converted from snake_case by KeyDecodingStrategy
}
