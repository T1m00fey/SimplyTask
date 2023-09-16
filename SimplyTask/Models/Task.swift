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
}

extension Task {
    static func getTasks() -> [Task] {
        return [
            Task(title: "Tasd sf djnnfsjndskndsndjsndjnsdjnjandkdbfjdasfjfbsbndnddsbfnbdnfbdnbfndbfnbdnfbdk", isDone: true),
            Task(title: "Task2", isDone: false),
            Task(title: "Task3", isDone: false)
        ]
    }
}
