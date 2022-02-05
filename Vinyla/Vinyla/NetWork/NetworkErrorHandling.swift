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
        guard let decodedData = try? JSONDecoder().decode(VinylaErrorModel.self, from: self.data) else { return nil }
        return decodedData
    }

}

enum NetworkError: Error {
    case bodyDataError
    case serverError
    case unexpectedError
}

struct VinylaErrorModel: Codable {
    let status: Int
    let success: Bool
    let message: String
}

extension VinylaErrorModel {
    var vinylaError: NetworkError? {
            switch self.status {
            case 200..<300: return nil
            case 400: return NetworkError.bodyDataError
            case 600: return NetworkError.serverError
            default: return NetworkError.unexpectedError
            }
    }
}
