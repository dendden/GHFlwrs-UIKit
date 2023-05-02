//
//  Follower.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

struct Follower: Codable, Hashable {

    let login: String
    let avatarUrl: String   // will be converted from snake_case by KeyDecodingStrategy

    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
