//
//  NetworkManager.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import UIKit

/// A singleton class performing network requests and
/// interpreting the results.
class NetworkManager {

    /// A shared `NetworkManager` object.
    static let shared = NetworkManager()

    let baseURL = "https://api.github.com/users/"
    let followersPerPage = 100

    /// A key-value cache for user avatar images keyed by their string `URL` addresses.
    let cache = NSCache<NSString, UIImage>()

    let decoder: JSONDecoder

    // important to have private init(), so that only class itself
    // can instantiate the singleton
    private init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

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

            guard let data else {
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

    /// Executes the task of fetching user JSON data and
    /// interpreting that data into a ``User`` struct.
    /// - Parameters:
    ///   - username: A name of user whose information must be
    ///   retrieved.
    ///   - completion: A result type with the ``User`` struct
    ///   in `.success` case and a descriptive ``GFNetworkError``
    ///   in case of `.failure`.
    func getUserInfo(
        for username: String,
        completion: @escaping (Result<User, GFNetworkError>) -> Void
    ) {

        let endpoint = baseURL + "\(username)"

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

            guard let data else {
                completion(.failure(.dataError))
                return
            }

            do {
                let user = try self.decodeJSON(data: data, as: User.self)
                completion(.success(user))
            } catch {
                completion(.failure(.jsonError))
            }
        }
        task.resume()
    }

    /// A helper method for decoding `JSON` data into a generic type.
    /// - Parameters:
    ///   - data: `JSON` data to decode.
    ///   - type: Type of data to receive as a result of decoding. Optional when
    ///   inferred from context.
    ///   - dateDecodingStrategy: Decoding strategy for `JSON` date formats. Default
    ///   value is **.iso8601**.
    ///   - keyDecodingStrategy: Decoding strategy for decoding parameter keys in `JSON`.
    ///   Default value is **.convertFromSnakeCase**.
    /// - Returns: Decoded data of the specified type.
    func decodeJSON<T: Decodable>(
        data: Data,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) throws -> T {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        return try decoder.decode(T.self, from: data)
    }

    /// Performs a `NetworkTask` for downloading an `UIImage` asset from the
    /// specified url string.
    /// - Parameters:
    ///   - urlString: A `String` representation of `URL` from which the
    ///   image must be downloaded.
    ///   - completion: A completion handler returning a `UIImage` if network
    ///   request was successful, or `nil` if any error occurred during request execution.
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {

        let cacheKey = NSString(string: urlString)

        // check if image is already in cache - so there's no need for download
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let networkTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard
                let self = self,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        networkTask.resume()
    }
}
