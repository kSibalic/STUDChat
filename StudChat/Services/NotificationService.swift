import Foundation
import UserNotifications
import SwiftUI
import BackgroundTasks

class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    private var lastMessageTimestamp: Date?
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        registerBackgroundTask()
    }
    
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.studchat.refresh", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
    }
    
    private func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.studchat.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
    
    private func handleBackgroundTask(task: BGAppRefreshTask) {
        scheduleBackgroundTask()
        
        let checkMessagesTask = Task {
            do {
                try await DatabaseService.shared.checkForNewMessages(since: lastMessageTimestamp)
            } catch {
                print("Error checking for new messages: \(error)")
            }
        }
        
        task.expirationHandler = {
            checkMessagesTask.cancel()
        }
        
        Task {
            await checkMessagesTask.value
            task.setTaskCompleted(success: true)
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
                self.scheduleBackgroundTask()
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
    
    func scheduleMessageNotification(from sender: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "New message from \(sender)"
        content.body = message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                          content: content,
                                          trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func updateLastMessageTimestamp(_ timestamp: Date) {
        lastMessageTimestamp = timestamp
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        Task {
            do {
                if let currentUser = AuthService.shared.currentUser {
                    try await DatabaseService.shared.updateUserPushToken(userId: currentUser.id!, token: token)
                }
            } catch {
                print("Error storing push token: \(error)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
