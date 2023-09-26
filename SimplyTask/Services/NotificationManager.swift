//
//  NotificationManager.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 16.09.2023.
//

import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func scheduleNotification(text: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Simply Task"
        content.body = text
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "\(text)\(date)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
        
        print("Notification with identifier \(text)\(date) added")
    }
    
    func deleteNotification(title: String, date: Date) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(title)\(date)"])
    }
}
