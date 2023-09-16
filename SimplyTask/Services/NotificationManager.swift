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
    
    func scheduleNotification(text: String, index: Int, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Simply Task"
        content.body = text
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "\(text)\(index)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
