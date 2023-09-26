//
//  List.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import Foundation

struct TaskList: Codable, Identifiable {
    var id = UUID()
    var title: String
    var numberOfTasks: Int
    var colorOfImportant: Int
    var isPrivate: Bool
    var tasks: [Task]
    var isDoneShowing: Bool
    var isMoveDoneToEnd: Bool
}

