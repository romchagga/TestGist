//
//  GistCommits.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import Foundation

struct GistCommits {
    let version: String
    let changeStatus: ChangeStatusCommit
}

extension GistCommits: Codable {
    enum CodingKeys: String, CodingKey {
        case version
        case changeStatus = "change_status"
    }
}

struct ChangeStatusCommit {
    let additions: Int
    let deletions: Int
}

extension ChangeStatusCommit: Codable {
    enum CodingKeys: String, CodingKey {
        case additions
        case deletions
    }
}

