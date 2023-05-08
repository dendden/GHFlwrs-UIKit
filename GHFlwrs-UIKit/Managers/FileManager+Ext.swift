//
//  FileManager+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

extension FileManager {

    /// A shortcut to the `URL` of `.documentsDirectory` in `.userDomainMask`.
    var documentsDirectory: URL? {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }

    /// Encodes data into a `JSON` file with provided name and persists this file
    /// in Documents Directory.
    /// - Parameters:
    ///   - fileName: Name of the file, into which the data must be saved.
    ///   - data: Data of any `Encodable` type to be encoded and persisted.
    ///   - dateEncodingStrategy: Encoding strategy for `JSON` date formats. Default
    ///   value is **.iso8601**.
    ///   - keyEncodingStrategy: Encoding strategy for encoding parameter keys in `JSON`.
    ///   Default value is **.useDefaultKeys**.
    func encodeToJSON<T: Encodable>(
        fileName: String,
        data: T,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    ) throws {

        guard let documentsDirectory = documentsDirectory else {
            fatalError("Unable to locate Documents Directory to write file.")
        }
        let fileURL = documentsDirectory.appending(path: fileName)

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

    /// Retrieves `JSON` data from the given file and decodes it into requested `Decodable` type.
    /// - Parameters:
    ///   - fileName: Name of the file that stores the data.
    ///   - type: Type of data to receive as a result of decoding. Optional when
    ///   inferred from context.
    ///   - dateDecodingStrategy: Decoding strategy for `JSON` date formats. Default
    ///   value is **.iso8601**.
    ///   - keyDecodingStrategy: Decoding strategy for decoding parameter keys in `JSON`.
    ///   Default value is **.useDefaultKeys**.
    /// - Returns: Decoded data of the specified type.
    func decodeFromJSON<T: Decodable>(
        fileName: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {

        guard let documentsDirectory = documentsDirectory else {
            fatalError("Unable to locate Documents Directory to write file.")
        }
        let fileURL = documentsDirectory.appending(path: fileName)

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
