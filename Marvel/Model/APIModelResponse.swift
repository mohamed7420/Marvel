//
//  APIModelResponse.swift
//  Marvel
//
//  Created by Mohamed Osama on 29/12/2023.
//

import Foundation
import RxDataSources
// MARK: - Welcome
struct APIModelResponse: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: Character
}

// MARK: - DataClass
struct Character: Codable {
    let offset, limit, total, count: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable, IdentifiableType, Equatable {
    typealias Identity = UUID
    var identity: UUID {
        UUID()
    }
    let id: Int
    let name, description: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLElement]

    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.identity == rhs.identity
    }
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
    let returned: Int
}

// MARK: - ComicsItem
struct ComicsItem: Codable, Hashable, Equatable {
    let resourceURI: String
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: ComicsItem, rhs: ComicsItem) -> Bool {
        return lhs.name == rhs.name
    }
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

// MARK: - StoriesItem
struct StoriesItem: Codable, Hashable, Equatable {
    let uuid = UUID()

    private enum CodingKeys : String, CodingKey { case name, type, resourceURI }

    var resourceURI: String?
    var name: String
    var type: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: StoriesItem, rhs: StoriesItem) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let fileExtension: String
    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable, Hashable {
    let type: String
    let url: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}
