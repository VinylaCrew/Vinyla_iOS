//
//  UploadUserVinylModel.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/28.
//

import Foundation

struct UploadUserVinylModel: Encodable {
    var title: String
    var artist: String
    var memo: String
    var image: Data
}


struct UploadUserVinylResponse: Decodable {
    struct Data: Decodable {
        let requestIdx: Int
    }
    let status: Int
    let success: Bool
    let message: String
    let data: Data?
}
