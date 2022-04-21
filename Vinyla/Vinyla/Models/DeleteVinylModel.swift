//
//  DeleteVinylModel.swift
//  Vinyla
//
//  Created by IJ . on 2022/04/02.
//

import Foundation

struct DeleteVinylResponse: Codable {

    struct Data: Codable {
        let id: String
    }

    let status: Int
    let success: Bool
    let message: String
    let data: Data?
}

