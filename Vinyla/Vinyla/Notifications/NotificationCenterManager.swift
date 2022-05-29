//
//  NotificationCenterManager.swift
//  Vinyla
//
//  Created by Zio.H on 2022/05/29.
//

import UIKit

final class NotificationCenterManager: NSObject {
    func pushNotificationsSettings() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
            
            guard granted else {
                print("😱사용자가 Push Notifications 거절함")
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        if UIApplication.shared.isRegisteredForRemoteNotifications != true {
            
        }
    }

}
