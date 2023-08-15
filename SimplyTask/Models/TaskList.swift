//
//  List.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

struct TaskList {
    var title: String
    var numberOfTasks: Int
    var colorOfImportant: Color
    var isPrivate: Bool
    var tasks: [Task]
}
