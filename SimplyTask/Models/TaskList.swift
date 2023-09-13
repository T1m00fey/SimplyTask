//
//  List.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI
import Foundation

struct TaskList: Codable {
    var title: String
    var numberOfTasks: Int
    var colorOfImportant: Int
    var isPrivate: Bool
    var tasks: [Task]
}

