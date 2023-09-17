//
//  Task.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.07.2023.
//

import Foundation

struct Task: Codable {
    var title: String
    var isDone: Bool
    var notificationDate: Date?
}
