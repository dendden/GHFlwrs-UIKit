//
//  PersistenceManager.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {

    static func updateBookmark(
        _ bookmark: Follower,
        actionType: PersistenceActionType,
        completion: @escaping (GFPersistenceError?) -> Void
    ) {

        retrieveBookmarks { result in

            switch result {

            case .success(let bookmarks):

                var updatingBookmarks = bookmarks

                switch actionType {
                case .add:
                    if !updatingBookmarks.contains(bookmark) {
                        updatingBookmarks.append(bookmark)
                    } else {
                        completion(.bookmarkExists)
                    }
                case .remove:
                    updatingBookmarks.removeAll { $0 == bookmark }
                }

                completion(saveBookmarks(updatingBookmarks))

            case .failure(let failure):
                completion(failure)
            }
        }
    }

    // MARK: - My variant using FileManager and Documents Directory with JSON
    enum Files {
        static let bookmarkedUsers = "bookmarked_users.json"
    }

    static func retrieveBookmarks(completion: @escaping (Result<[Follower], GFPersistenceError>) -> Void) {
        do {
            let bookmarks = try FileManager.default.decodeFromJSON(file: Files.bookmarkedUsers, as: [Follower].self)
            completion(.success(bookmarks))
        } catch GFPersistenceError.dataReadError {
            // file doesn't exist, so it's a first read
            completion(.success([]))
        } catch {
            completion(.failure(.dataDecodeError))
        }
    }

    static func saveBookmarks(_ bookmarks: [Follower]) -> GFPersistenceError? {
        do {
            try FileManager.default.encodeToJSON(file: Files.bookmarkedUsers, data: bookmarks)
            return nil
        } catch GFPersistenceError.dataEncodeError {
            return .dataEncodeError
        } catch {
            return .writeError
        }
    }

    // MARK: - SA's variant using UserDefaults:

    enum DefaultsKeys {
        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard

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
