//
//  NSCacheManager.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/30.
//

import UIKit

class NSCacheManager {
    static let shared = NSCache<NSString, UIImage>()

    private init() {

    }
}
