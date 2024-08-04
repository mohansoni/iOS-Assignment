//
//  ReelsModel.swift
//  iOS Assignment
//
//  Created by Mohan Soni on 03/08/24.
//

import Foundation

// MARK: - Welcome
struct ReelsData: Codable {
    let reels: [Reel]
}

// MARK: - Reel
struct Reel: Codable {
    let arr: [Arr]
}

// MARK: - Arr
struct Arr: Codable {
    let id: String
    let video: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case video, thumbnail
    }
}

