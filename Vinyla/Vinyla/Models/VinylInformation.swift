//
//  VinylInformation.swift
//  Vinyla
//
//  Created by IJ . on 2021/10/22.
//

import Foundation

struct VinylInformation: Codable {

    struct Data: Codable {
        let id: Int
        let title, artist: String
        let image: String
        let year: Int
        let genres: [String]
        let tracklist: [Tracklist]
        let rate, rateCount: Int
    }

    let status: Int
    let success: Bool
    let message: String
    let data: Data
}


struct Tracklist: Codable {
    let position, type, title, duration: String

    enum CodingKeys: String, CodingKey {
        case position
        case type = "type_"
        case title, duration
    }
}
