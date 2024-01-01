//
//  ConfigurationManager.swift
//  Marvel
//
//  Created by Mohamed Osama on 28/12/2023.
//

import Foundation
import CryptoKit

struct ConfigurationManager {

    enum ConfigurationError: Error {
        case invalidPath
        case invalidInfo
    }

    static let shared = ConfigurationManager()
    private let fileName = "Configuration"

    private init() { }

    var baseURL: String {
        guard let urlString = try? baseURLInfo()["baseURL"] as? String else { return "" }
        return urlString
    }

    public var apiKey: String? {
        privateKey + publicKey
    }

    public var privateKey: String {
        guard let info = try? baseURLInfo(),
              let privateKey = info["privateKey"] as? String else { return "" }
        return privateKey
    }

    public var publicKey: String {
        guard let info = try? baseURLInfo(),
              let publicKey = info["publicKey"] as? String else { return "" }
        return publicKey
    }

    func baseURLInfo() throws -> NSDictionary {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            throw ConfigurationError.invalidPath
        }

        guard let info = NSDictionary(contentsOfFile: path) else {
            throw ConfigurationError.invalidInfo
        }

        return info
    }

    func generateMarvelAPIHash(timestamp: String) -> String {
        let preHash = timestamp + privateKey + publicKey
        return preHash.md5
    }
}
