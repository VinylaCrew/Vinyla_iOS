//
//  SaveVinylModel.swift
//  Vinyla
//
//  Created by IJ . on 2022/03/13.
//

import Foundation

struct RequestSaveVinylModel: Encodable {
    let id: Int
    let title, artist: String
    let image: String
    let year: Int
    let genres: [String]
    let tracklist: [String]
    var rate: Int?
    var comment: String?
}

struct ResponseSaveVinylModel: Decodable {
    struct Data: Decodable {
        let vinylIdx: Int
    }
    let data: Data?
}

