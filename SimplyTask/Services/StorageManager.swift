//
//  StorageManager.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.09.2023.
//

import SwiftUI
import UserNotifications

final class StorageManager {
    
    static let shared = StorageManager()
    init() {}
    
    private let userDefaults = UserDefaults.standard
    private let key = "lists"
    
    func newTask(toList index: Int, newTask task: Task) {
        var lists = fetchData()
        lists[index].tasks.append(task)
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchData() -> [TaskList] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let lists = try? JSONDecoder().decode([TaskList].self, from: data) else { return [] }
        
        return lists
    }
    
    func new(list: TaskList) {
        var lists = fetchData()
        lists.append(list)
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func resave(title: String, colorOfImportant: Int, isPrivate: Bool, isDoneShowing: Bool, isMoveDoneToEnd: Bool, atIndex index: Int) {
        var lists = fetchData()
        lists[index].title = title
        lists[index].colorOfImportant = colorOfImportant
        lists[index].isPrivate = isPrivate
        lists[index].isDoneShowing = isDoneShowing
        lists[index].isMoveDoneToEnd = isMoveDoneToEnd
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func toggleIsDone(indexOfTask taskIndex: Int, indexOfList listIndex: Int) {
        var lists = fetchData()
        lists[listIndex].tasks[taskIndex].isDone.toggle()
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteTask(atList listIndex: Int, atIndex taskIndex: Int) {
        var lists = fetchData()
        lists[listIndex].tasks.remove(at: taskIndex)
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteList(atIndex index: Int) {
        var notificationIdentifiers: [String] = []
        
        var lists = fetchData()
        
        for indexOfTask in 0..<lists[index].tasks.count {
            notificationIdentifiers.append("\(lists[index].tasks[indexOfTask].title)\(lists[index].tasks[indexOfTask].notificationDate ?? Date.now)")
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
        
        lists.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteLastList() {
        var lists = fetchData()
        lists.removeLast()
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func plusOneTask(atIndex index: Int) {
        var lists = fetchData()
        lists[index].numberOfTasks += 1
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteOneTask(atIndex index: Int) {
        var lists = fetchData()
        lists[index].numberOfTasks -= 1
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func editTask(indexOfList listIndex: Int, indexOfTask taskIndex: Int, newTitle: String) {
        var lists = fetchData()
        lists[listIndex].tasks[taskIndex].title = newTitle
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func addDateToTask(taskIndex: Int, listIndex: Int, date: Date) {
        var lists = fetchData()
        lists[listIndex].tasks[taskIndex].notificationDate = date
        lists[listIndex].tasks[taskIndex].isNotificationDone = false
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteDateInTask(taskIndex: Int, listIndex: Int) {
        var lists = fetchData()
        lists[listIndex].tasks[taskIndex].notificationDate = nil
        lists[listIndex].tasks[taskIndex].isNotificationDone = false
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteAll() {
        var lists = fetchData()
        lists = []
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func save(name: String) {
        userDefaults.set(name, forKey: "name")
    }
    
    func fetchName() -> String {
        let name = userDefaults.string(forKey: "name")
        
        return name ?? ""
    }
    
    func deleteName() {
        userDefaults.set("", forKey: "name")
    }
    
    func newLists(lists: [TaskList]) {
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func toggleIsNotificationDone(taskIndex: Int, listIndex: Int) {
        var lists = fetchData()
        lists[listIndex].tasks[taskIndex].isNotificationDone = true
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func moveTaskToEnd(listIndex: Int, taskIndex: Int) {
        var lists = fetchData()
        lists[listIndex].tasks.move(fromOffsets: IndexSet(integer: taskIndex), toOffset: lists[listIndex].tasks.count)
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func moveTaskToBegin(listIndex: Int, taskIndex: Int) {
        var lists = fetchData()
        
        for indexOfTask in 0..<taskIndex {
            if lists[listIndex].tasks[indexOfTask].isDone {
                lists[listIndex].tasks.move(fromOffsets: IndexSet(integer: taskIndex), toOffset: 0)
                break;
            }
        }
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func setTheme(isDark: Bool) {
        userDefaults.set(isDark, forKey: "theme")
    }
    
    func getTheme() -> Bool {
        return userDefaults.bool(forKey: "theme")
    }
    
    func getDoneOfNotifications() {
        var lists = fetchData()
        
        for listIndex in 0..<lists.count {
            for taskIndex in 0..<lists[listIndex].tasks.count {
                if lists[listIndex].tasks[taskIndex].notificationDate != nil {
                    if lists[listIndex].tasks[taskIndex].notificationDate ?? Date.now <= Date.now {
                        lists[listIndex].tasks[taskIndex].isNotificationDone = true
                    }
                }
            }
        }
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
}
