//
//  FileManager+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

extension FileManager {

    var documentsDirectory: URL? {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }

    func encodeToJSON<T: Encodable>(
        file: String,
        data: T,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    ) throws {
        guard let documentsDirectory = documentsDirectory else {
            fatalError("Unable to locate Documents Directory to write file.")
        }
        let fileURL = documentsDirectory.appending(path: file)

        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = dateEncodingStrategy
        jsonEncoder.keyEncodingStrategy = keyEncodingStrategy

        do {
            let encodedData = try jsonEncoder.encode(data)
            try encodedData.write(to: fileURL, options: .atomic)
        } catch EncodingError.invalidValue(_, _) {
            throw GFPersistenceError.dataEncodeError
        } catch {
            throw GFPersistenceError.writeError
        }
    }

    func decodeFromJSON<T: Decodable>(
        file: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {
        guard let documentsDirectory = documentsDirectory else {
            fatalError("Unable to locate Documents Directory to write file.")
        }
        let fileURL = documentsDirectory.appending(path: file)

        guard let data = try? Data(contentsOf: fileURL) else {
            throw GFPersistenceError.dataReadError
        }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw GFPersistenceError.dataDecodeError
        }
    }
}
