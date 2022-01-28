//
//  APITarget.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//
import Foundation
import Moya

enum APITarget: TargetType {
    //MARK: - User API
    case createUser(userData: SignUpRequest)
    case checkNickName(body: NickNameCheckRequest)
    //MARK: - Vinyla APP Logic API
    case vinylSearch(urlParameters: String?)
    case getVinylDetail(pathVinylID: Int?)
    case getVinylBoxMyData

    var baseURL: URL {
        return URL(string:ServerHost.develop)!
    }

    var path: String {
        switch self {
        case .createUser:
            return "/users/signup"
        case .checkNickName:
            return "/users/check"
        case .vinylSearch:
            return "/vinyls/search"
        case let .getVinylDetail(pathVinylID): //Path Variable
            return "/vinyls/search/" + String(pathVinylID ?? -1)
        case .getVinylBoxMyData:
            return "/vinyls/my"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
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
        case let .createUser(userData):
            guard let encodedData = try? JSONEncoder().encode(userData) else {
                return .requestData(Data())
            }
            return .requestData(encodedData)
        case let .checkNickName(nickName):
            guard let encodedData = try? JSONEncoder().encode(nickName) else {
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
            return ["Content-Type" : "application/json", "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHgiOjIyLCJmdWlkIjoiYXNkZnRlc3QxMTExMjIyMiIsImlhdCI6MTY0MzAyNzMzMywiZXhwIjoxNjc0NTYzMzMzLCJpc3MiOiJoYWVseSJ9.7KbvuO3GmVlPqqMokkHzmDPDr8dpJ8gBYEy4ONVfvX4"]
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
