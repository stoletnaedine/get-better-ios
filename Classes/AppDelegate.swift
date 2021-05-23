//
//  AppDelegate.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04/02/2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import IQKeyboardManagerSwift
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    private let rootRouter: RootRouterProtocol = RootRouter()
    private lazy var database: DatabaseProtocol = FirebaseDatabase()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase config
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        database.keepSyncedPosts()
        Auth.auth().languageCode = Locale.current.languageCode == "ru" ? "ru" : "en"

        registerPushNotifications()

        IQKeyboardManager.shared.enable = true

        setupNavigationBar()

        rootRouter.startApp(completion: nil)
        
        return true
    }
    
    /// This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase registration token: \(fcmToken)")
        let dataDict: [String: String] = ["token": fcmToken]
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    /// Обработка push с ключом
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let info = userInfo as NSDictionary
        if let topicName = info.value(forKey: Constants.topicKey) as? String {
            if let topic = NotificationTopic(rawValue: topicName) {
                switch topic {
                case .post:
                    rootRouter.showAddPost()
                case .tip:
                    rootRouter.showTip()
                }
            }
        }

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
    }

    private func registerPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: { _, _ in })
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }

}

extension AppDelegate {
    
    private enum Constants {
        static let gcmMessageIDKey = "gcm.Message_ID"
        static let topicKey = "topic"
    }

    private func setupNavigationBar() {
        UINavigationBar.appearance().tintColor = .darkGray
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
    }
    
}
