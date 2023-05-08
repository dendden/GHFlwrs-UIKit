//
//  GFNetworkError.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

/// An Error thrown by ``NetworkManager`` when any listed issue occurs.
enum GFNetworkError: String, Error {

    case invalidURL = "Could not perform request due to bad URL - please try again."
    case connectionError = "Unable to complete request - check your connection."
    case invalidResponse = "Invalid server response - please try again."
    case dataError = "Unable to read data received from server - please try again."
    case jsonError = "Failed to read data due to an error."
}
