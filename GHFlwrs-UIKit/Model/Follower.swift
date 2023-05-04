//
//  Follower.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

struct Follower: Codable, Equatable, Hashable {

    let login: String
    let avatarUrl: String   // will be converted from snake_case by KeyDecodingStrategy

    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }

    static func == (lhs: Follower, rhs: Follower) -> Bool {
        lhs.login == rhs.login
    }
}
