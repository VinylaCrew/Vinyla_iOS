//
//  SearchModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//

import Foundation

struct SearchModel: Codable {
    struct Data: Codable {
        let id: Int?
        let thumb: String?
        let title, artist: String?
    }
        let status: Int?
        let success: Bool?
        let responseMessage: String?
        let data: [Data?]
}
