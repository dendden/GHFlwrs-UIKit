//
//  GFPersistenceError.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

enum GFPersistenceError: String, Error {

    case dataEncodeError = "Unable to encode data to JSON format."
    case writeError = "There was a problem writing data to file."

    case dataReadError = "Unable to read data from file."
    case dataDecodeError = "Unable to decode data from JSON format."

    case bookmarkExists = "You have already bookmarked this user. 📌"
}
