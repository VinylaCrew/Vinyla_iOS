//
//  NickNameRequestModel.swift
//  Vinyla
//
//  Created by IJ . on 2022/01/14.
//

import Foundation

struct NickNameCheckResponse: Decodable {
    struct Data: Decodable {
        let nickname: String
    }
    let status: Int
    let success: Bool
    let message: String
    let data: Data?
}

struct NickNameCheckRequest: Encodable {
    var nickname: String?
}
