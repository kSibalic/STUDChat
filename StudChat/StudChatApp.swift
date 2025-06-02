//
//  StudChatApp.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

@main
struct StudChatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request notification permissions
        NotificationService.shared.requestAuthorization()
        
        // Enable background fetch
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
    
    // Handle receiving remote notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the notification
        if let message = userInfo["message"] as? String,
           let sender = userInfo["sender"] as? String {
            NotificationService.shared.scheduleMessageNotification(from: sender, message: message)
        }
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Task {
            do {
                try await DatabaseService.shared.checkForNewMessages(since: nil)
                completionHandler(.newData)
            } catch {
                completionHandler(.failed)
            }
        }
    }
}
