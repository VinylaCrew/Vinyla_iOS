//
//  APITarget.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//

import Moya

enum APITarget: TargetType {
    case vinylSearch(urlParameters: String?)

    var baseURL: URL {
        return URL(string:"http://")!
    }

    var path: String {
        switch self {
        case .vinylSearch:
            return "/vinyls/search"
        }
    }

    var method: Method {
        switch self {
        case .vinylSearch:
            return .get
        }
    }

    var sampleData: Data {
        return .init()
    }

    var task: Task {
        switch self {
        case let .vinylSearch(urlParameters):
            if let vinylName = urlParameters {
                return .requestParameters(parameters: ["q" : vinylName], encoding: URLEncoding.default)
            }
            print("User Nick Name Error")
            return .requestParameters(parameters: ["q" : "error"], encoding: URLEncoding.default)

        }
    }

    var headers: [String : String]? {
        switch self {
        
        default: return ["Content-Type": "application/json"]
        }
    }
}
