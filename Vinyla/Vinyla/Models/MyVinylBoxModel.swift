//
//  MyVinylBoxModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/12/02.
//

import Foundation

struct MyVinylBoxModel: Codable {
    struct Data: Codable {
        let userIdx: Int?
        let myVinyls: [MyVinyl?]
    }
    let status: Int
    let success: Bool
    let message: String
    let data: Data?
}


// MARK: - MyVinyl
struct MyVinyl: Codable {
    let vinylIdx: Int
    let title: String
    let imageURL: String?
    let artist: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case vinylIdx, title
        case imageURL = "imageUrl"
        case artist, id
    }
}
