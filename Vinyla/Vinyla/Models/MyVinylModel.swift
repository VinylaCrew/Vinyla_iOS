//
//  MyVinyl.swift
//  Vinyla
//
//  Created by IJ . on 2022/04/17.
//

import Foundation

struct MyVinylRequest: Encodable {
    let vinylIdx: Int?
}

struct MyVinylResponse: Decodable {
    struct Data: Codable {
        let repVinyl: Int
    }

    let status: Int
    let success: Bool
    let message: String
    let data: Data?
}

