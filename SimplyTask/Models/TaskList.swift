//
//  List.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import RealmSwift

class TaskList: Object {
    var title = ""
    var numberOfTasks = 0
    var colorOfImportant = 0
    var isPrivate = false
    var tasks = List<Task>()
}
