//
//  NetworkManager+Async.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 08.05.2023.
//

import UIKit

extension NetworkManager {

    /// Creates a `URL` from string and asynchronously performs `URLSession` request for data.
    ///
    /// This method can throw ``GFNetworkError``:
    /// + ``GFNetworkError/invalidURL`` when failed to create `URL` from string.
    /// + ``GFNetworkError/connectionError`` when `URLSession` fails.
    /// + ``GFNetworkError/invalidResponse`` when response status code is different from 200.
    /// - Parameter urlString: A string presentation of data `URL`.
    /// - Returns: `Data` object fetched with `URLSession` request.
    private func requestDataFromUrlString(_ urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw GFNetworkError.invalidURL
        }

        var urlRequestResult: (data: Data, response: URLResponse)
        do {
            urlRequestResult = try await URLSession.shared.data(from: url)
        } catch {
            throw GFNetworkError.connectionError
        }

        guard
            let httpResponse = urlRequestResult.response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw GFNetworkError.invalidResponse
        }

        return urlRequestResult.data
    }

    /// An *async* variant of ``NetworkManager/getFollowers(for:page:completion:)`` method.
    /// - Parameters:
    ///   - username: A name of user whose followers must be retrieved.
    ///   - page: The number of page with fetch results.
    /// - Returns: An array of followers retrieved from the URL request.
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {

        let parameters = "per_page=\(followersPerPage)&page=\(page)"
        let endpoint = baseURL + "\(username)/followers?\(parameters)"

        let urlData = try await requestDataFromUrlString(endpoint)

        do {
            return try decoder.decode([Follower].self, from: urlData)
        } catch {
            throw GFNetworkError.jsonError
        }
    }

    /// An *async* variant of ``NetworkManager/getUserInfo(for:completion:)`` method.
    /// - Parameter username: A name of user whose information must be retrieved.
    /// - Returns: A `User` object decoded from `URLResponse` data.
    func getUserInfo(for username: String) async throws -> User {

        let endpoint = baseURL + "\(username)"

        let urlData = try await requestDataFromUrlString(endpoint)

        do {
            return try decoder.decode(User.self, from: urlData)
        } catch {
            throw GFNetworkError.jsonError
        }
    }

    /// An *async* variant of ``NetworkManager/downloadImage(from:completion:)`` method.
    /// - Parameter urlString: A `String` representation of `URL` from which the
    ///   image must be downloaded.
    /// - Returns: An image if `URLSession` or `cache` query was successful, `nil` otherwise.
    func downloadImage(from urlString: String) async -> UIImage? {

        let cacheKey = NSString(string: urlString)

        // check if image is already in cache - so there's no need for download
        if let image = cache.object(forKey: cacheKey) { return image }

        guard
            let urlData = try? await requestDataFromUrlString(urlString),
            let image = UIImage(data: urlData)
        else { return nil }

        cache.setObject(image, forKey: cacheKey)

        return image
    }
}
