//
//  AppDelegate.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: ADMOB_PUB_ID)
        Fabric.with([Crashlytics.self])
        
        // [START FCM settings]
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in }
        )
        application.registerForRemoteNotifications()
        #if DEBUG
            let token = Messaging.messaging().fcmToken
            print("FCM token: \(token ?? "")")
        #endif
        // [END FCM settings]
        
        return true
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {

    // Called when
    // 1. FCM push comes when app is foreground
    // 2. User taps notification and launched app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        // TODO : もし既読が反映されなかったら、 http://xyk.hatenablog.com/entry/2016/11/04/140900 を実装
        
        completionHandler()
    }
}

