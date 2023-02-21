//
//  Gist.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import Foundation

struct Gist {
    let url: String
    let owner: OwnerGist
    let id: String
    let description: String
    let createdAt: String
    let files: [String : FileGist]
}

extension Gist: Codable {
    enum CodingKeys: String, CodingKey {
        case url
        case owner
        case id
        case createdAt = "created_at"
        case files
        case description
    }
}

struct OwnerGist {
    let login: String
    let avatarUrl: String
}

extension OwnerGist: Codable {
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }
}

struct FileGist {
    let filename: String
    let type: String
    let content: String?
}

extension FileGist: Codable {
    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case content
}
}
