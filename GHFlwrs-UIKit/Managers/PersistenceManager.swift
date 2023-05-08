//
//  PersistenceManager.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

/// A selection of **add** or **remove** action to perform on
/// persisted array of `Bookmarks`.
enum PersistenceActionType {

    case add, remove
}

/// An entity that performs CRUD operations on bookmarked users
/// persisted in Documents directory of the device.
enum PersistenceManager {

    /// An array of usernames that are stored as bookmarked users.
    ///
    /// This array is retrieved on app launch in `application(didFinishLaunchingWithOptions)`
    /// method of `AppDelegate` for quick reference on bookmarked state. It gets updated
    /// every time an `add` or `removed` operation is performed on bookmarked users.
    static var allBookmarkedUsers: [String] = []

    /// Updates the persisted array of bookmarked user, either adding new bookmarks
    /// or deleting existing.
    ///
    /// This method also updates ``allBookmarkedUsers`` array of usernames.
    /// - Parameters:
    ///   - bookmark: A user to persist as a bookmark, presented here as `Follower` type.
    ///   - actionType: An action to perform on persisted bookmarks: add new one or
    ///   delete existing.
    ///   - completion: A completion handler returning an error describing any problem that
    ///   occurred when persisting changes to bookmarks, or `nil` if operation was successful.
    static func updateWith(
        _ bookmark: Follower,
        actionType: PersistenceActionType,
        completion: @escaping (GFPersistenceError?) -> Void
    ) {

        retrieveBookmarks { result in

            switch result {
            case .success(var bookmarks):

                switch actionType {
                case .add:
                    if !bookmarks.contains(bookmark) {
                        bookmarks.append(bookmark)
                        allBookmarkedUsers.append(bookmark.login)
                    } else {
                        completion(.bookmarkExists)
                        return
                    }
                case .remove:
                    bookmarks.removeAll { $0 == bookmark }
                    allBookmarkedUsers.removeAll { $0 == bookmark.login }
                }

                completion(saveBookmarks(bookmarks))

            case .failure(let failure):
                completion(failure)
            }
        }
    }

    // MARK: - My variant using FileManager and Documents Directory with JSON

    /// A collection of file names used in data persistence operations.
    enum Files {

        static let bookmarkedUsers = "bookmarked_users.json"
    }

    /// Retrieves and decodes bookmarked users from persistent storage.
    /// - Parameter completion: A completion handler returning a `Result` type
    /// with an array of ``Follower`` objects as bookmarked users in case of success,
    /// or an error describing the problem that occurred during decoding in case of failure.
    static func retrieveBookmarks(completion: @escaping (Result<[Follower], GFPersistenceError>) -> Void) {

        do {
            let bookmarks = try FileManager.default.decodeFromJSON(fileName: Files.bookmarkedUsers, as: [Follower].self)
            completion(.success(bookmarks))
        } catch GFPersistenceError.dataReadError {
            // file doesn't exist, so it's a first read
            completion(.success([]))
        } catch {
            completion(.failure(.dataDecodeError))
        }
    }

    /// Encodes and writes the array of bookmarked users to persistent storage.
    /// - Parameter bookmarks: Array of users to persist as bookmarks.
    /// - Returns: An error if a problem occurred during encoding or writing
    /// to storage, or `nil` if operation was successful.
    static func saveBookmarks(_ bookmarks: [Follower]) -> GFPersistenceError? {

        do {
            try FileManager.default.encodeToJSON(fileName: Files.bookmarkedUsers, data: bookmarks)
            return nil
        } catch GFPersistenceError.dataEncodeError {
            return .dataEncodeError
        } catch {
            return .writeError
        }
    }

    // MARK: - SA's variant using UserDefaults:

    /// Collection of `UserDefaults` keys for persisting data. NOT used in this app.
    enum DefaultsKeys {

        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard

    /// Retrieves persisted bookmarks from `UserDefaults`.
    /// - Parameter completion: A completion handler returning a `Result` type
    /// with an array of ``Follower`` objects as bookmarked users in case of success,
    /// or an error describing the problem that occurred during decoding in case of failure.
    ///
    /// NOT used in this app.
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFPersistenceError>) -> Void) {

        guard
            let favoritesData = defaults.data(forKey: DefaultsKeys.favorites)
        else {
            completion(.success([]))
            return
        }

        let decoder = JSONDecoder()
        do {
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.dataDecodeError))
        }
    }

    /// Encodes and writes the array of bookmarked users to persistent storage.
    /// - Parameter bookmarks: Array of users to persist as bookmarks.
    /// - Returns: An error if a problem occurred during encoding or writing
    /// to storage, or `nil` if operation was successful.
    ///
    /// NOT used in this app.
    static func saveFavorites(_ favorites: [Follower]) -> GFPersistenceError? {

        let encoder = JSONEncoder()
        do {
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: DefaultsKeys.favorites)
            return nil
        } catch {
            return .dataEncodeError
        }
    }
}
