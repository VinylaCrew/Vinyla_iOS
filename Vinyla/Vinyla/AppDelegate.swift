//
//  AppDelegate.swift
//  Vinyla
//
//  Created by IJ . on 2021/06/27.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        DIContainer.shared.register(SignUpViewModel())
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "Not Found")
        
        ///Firebase Setting
        FirebaseApp.configure()
        
        ///UserNotifications + FirbaseMessage Setting
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        /// First App Launch Check
        checkAppFirstrunOrUpdateStatus()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }

        return false
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        if VinylaUserManager.fcmToken != fcmToken {
            VinylaUserManager.fcmToken = fcmToken
        }

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
      }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) { completionHandler()
    }
    
}

extension AppDelegate {
    func checkAppFirstrunOrUpdateStatus() {
        let bundleShortVersionString = "CFBundleShortVersionString"
        let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: bundleShortVersionString) as? String
        let versionOfLastRun = UserDefaults.standard.object(forKey: UserDefaultsKey.appVersionOfLastRun) as? String
        
        print("AppCurrentVersion:",currentAppVersion)
//         print(#function, currentVersion ?? "", versionOfLastRun ?? "")
        
        if versionOfLastRun == nil {
//            firstrun
            VinylaUserManager.explainInstagramShare = false
            VinylaUserManager.explainHomeButton = false
            VinylaUserManager.userVinylIndex = 0
        } else if versionOfLastRun != currentAppVersion {
//            updated
        } else {
//            nothingChanged
        }
        
        UserDefaults.standard.set(currentAppVersion, forKey: UserDefaultsKey.appVersionOfLastRun)
    }
}
