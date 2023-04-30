//
//  NetworkManager.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

/// A singleton performing network requests and
/// interpreting the results.
class NetworkManager {

    static let shared = NetworkManager()

    let baseURL = "https://api.github.com/users/"
    let followersPerPage = 100

    // important to have private init(), so that only class itself
    // can instantiate the singleton
    private init() {}

    /// Executes the task of fetching followers JSON data and
    /// interpreting that data into an array of `Follower`s
    /// - Parameters:
    ///   - username: A name of user whose followers must be
    ///   retrieved.
    ///   - page: The number of page with fetch results.
    ///   - completion: A result type with the list of `Followers`
    ///   in `.success` case and a descriptive ``GFNetworkError``
    ///   in case of `.failure`.
    func getFollowers(
        for username: String,
        page: Int,
        completion: @escaping (Result<[Follower], GFNetworkError>) -> Void
    ) {
        let parameters = "per_page=\(followersPerPage)&page=\(page)"
        let endpoint = baseURL + "\(username)/followers?\(parameters)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(.failure(.connectionError))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.dataError))
                return
            }

            do {
                let followers = try self.decodeJSON(data: data, as: [Follower].self)
                completion(.success(followers))
            } catch {
                completion(.failure(.jsonError))
            }
        }
        task.resume()
    }

    private func decodeJSON<T: Decodable>(
        data: Data,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) throws -> T {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        return try decoder.decode(T.self, from: data)
    }
}
