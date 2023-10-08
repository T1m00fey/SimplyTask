//
//  Task.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.07.2023.
//

import SwiftUI

struct StructTask: Codable, Identifiable {
    var id = UUID()
    var title: String
    var isDone: Bool
    var notificationDate: Date?
    var isNotificationDone: Bool
    var images: [Data]
    var creationDate: Date
    var isDateShowing: Bool
}
