//
//  AppStoreSupport.swift
//  Vinyla
//
//  Created by Zio.H on 2022/07/13.
//

import UIKit
import StoreKit

extension UIApplication {
    static func requestAppStoreReviewIfNeed() {
        if VinylaUserManager.appStoreReviewDate == nil {
            self.requestAppStoreReview()
            VinylaUserManager.appStoreReviewDate = Date().toString()
        }

    }
    
    static func requestAppStoreReview() {
        SKStoreReviewController.requestReview()
    }
    
    
    static func requestReviewManually() {
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1626702324?action=write-review") else {
            print("리뷰 이동 실패")
            return
        }
        
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
