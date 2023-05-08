//
//  User.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

/// An object representing full information about a GitHub user.
struct User: Codable {

    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?

    var publicRepos: Int
    var publicGists: Int

    /// URL address of user's profile on github.com.
    var htmlUrl: String

    var following: Int
    var followers: Int
    var followersUrl: String

    /// A date when user joined GitHub.
    let createdAt: Date
}
