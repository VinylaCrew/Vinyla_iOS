//
//  NetworkError.swift
//  Vinyla
//
//  Created by IJ . on 2022/02/02.
//

import Foundation
import Moya

extension Moya.Response {

    var vinylaErrorModel: VinylaErrorModel? {
        guard let decodeData = try? JSONDecoder().decode(VinylaErrorModel.self, from: self.data) else { return nil }
        return decodeData
    }

}

enum NetworkError: Error {
    case decodingError
}

struct VinylaErrorModel: Codable {
    let status: Int
    let success: Bool
    let message: String
}
