//
//  ErrorMessage.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

enum GFNetworkError: String, Error {

    case invalidURL = "Could not perform request due to bad URL - please try again."
    case connectionError = "Unable to complete request - check your connection."
    case invalidResponse = "Invalid server response - please try again."
    case dataError = "Unable to read data received from server - please try again."
    case jsonError = "Failed to data data due to an error."
}
