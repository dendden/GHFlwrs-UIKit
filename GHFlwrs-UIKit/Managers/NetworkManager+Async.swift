//
//  NetworkManager+Async.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 08.05.2023.
//

import Foundation

extension NetworkManager {

    /// An *async* variant of ``NetworkManager/getFollowers(for:page:completion:)`` method.
    /// - Parameters:
    ///   - username: A name of user whose followers must be retrieved.
    ///   - page: The number of page with fetch results.
    /// - Returns: An array of followers retrieved from the URL request.
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {

        let parameters = "per_page=\(followersPerPage)&page=\(page)"
        let endpoint = baseURL + "\(username)/followers?\(parameters)"

        guard let url = URL(string: endpoint) else {
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

        do {
            return try decoder.decode([Follower].self, from: urlRequestResult.data)
        } catch {
            throw GFNetworkError.jsonError
        }
    }
}
