//
//  User.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

struct User: Codable {

    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?

    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String

    var following: Int
    var followers: Int
    var followersUrl: String

    let createdAt: String
}
