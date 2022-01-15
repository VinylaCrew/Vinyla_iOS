//
//  APITarget.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//
import Foundation
import Moya

enum APITarget: TargetType {
    case checkNickName(body: NickNameCheckRequest)
    case vinylSearch(urlParameters: String?)
    case getVinylDetail(pathVinylID: Int?)
    case getVinylBoxMyData

    var baseURL: URL {
        return URL(string:"http://13.209.245.76:3000")!
    }

    var path: String {
        switch self {
        case .checkNickName:
            return "/users/check"
        case .vinylSearch:
            return "/vinyls/search"
        case let .getVinylDetail(pathVinylID)://Path Variable
            return "/vinyls/search/" + String(pathVinylID ?? -1)
        case .getVinylBoxMyData:
            return "/vinyls/my"
        }
    }

    var method: Moya.Method {
        switch self {
        case .checkNickName:
            return .post
        case .vinylSearch:
            return .get
        case .getVinylDetail:
            return .get
        case .getVinylBoxMyData:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .vinylSearch(_):
//            return "[{\"name\": \"\(String(describing: urlParameters))\"}]".data(using: .utf8)!
            return responseJSON("SearchMockData")
        case .getVinylDetail(_):
            return responseJSON("VinylDetailMockData")
        case .getVinylBoxMyData:
            return responseJSON("VinylBoxMockData")
        default:
            return .init()
        }
    }

    var task: Task {
        switch self {
        case let .checkNickName(body):
            guard let encodedData = try? JSONEncoder().encode(body) else {
                return .requestData(Data())
            }
            return .requestData(encodedData)
        case let .vinylSearch(urlParameters):
            if let vinylName = urlParameters {
                return .requestParameters(parameters: ["q" : vinylName], encoding: URLEncoding.default)
            }
            print("Vinyl Name Error")
            return .requestParameters(parameters: ["q" : "error"], encoding: URLEncoding.default)
        case .getVinylDetail(_):
            return .requestPlain
        case .getVinylBoxMyData:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .vinylSearch(_), .getVinylDetail(_), .getVinylBoxMyData:
            return ["Content-Type" : "application/json", "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHgiOjE3LCJpYXQiOjE2NDIwNjM2ODQsImV4cCI6MTY0MjA4MTY4NCwiaXNzIjoiaGFlbHkifQ.EDjL6oTqsI1MnpJj5rXP3zFvnpMrjyG2yOWXWFOeijI"]
        default: return ["Content-Type" : "application/json"]
        }
    }
}

func responseJSON(_ fileName: String) -> Data! {
    @objc class TestClass: NSObject {}

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: fileName, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
