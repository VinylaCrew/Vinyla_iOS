//
//  UserDefaultWrapper.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/30.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let storage: UserDefaults

    var wrappedValue: T? {
        get { self.storage.object(forKey: self.key) as? T }
        set {
            if newValue == nil { self.storage.removeObject(forKey: self.key) }
            else { self.storage.set(newValue, forKey: self.key) }
        }
    }
    
    init(key: String, storage: UserDefaults = .standard) {
        self.key = key
        self.storage = storage
    }
}
