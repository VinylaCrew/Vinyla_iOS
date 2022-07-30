//
//  DIContainer.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/28.
//

import Foundation

final class DIContainer {
    private var storage: [String: AnyObject] = [:]
    
    static let shared = DIContainer()
    private init() {}
    //현재 DIContainer는 ViewModel이 1:1 대응이라 필요없지만, 추후 네트워크 객체를 DIContainer 활용하면 될듯
    
    func register(_ object: AnyObject) {
        let key = String(reflecting: type(of: object))
        storage[key] = object
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(reflecting: type)
        guard let object = storage[key] as? T else { return nil }
        return object
    }
}
