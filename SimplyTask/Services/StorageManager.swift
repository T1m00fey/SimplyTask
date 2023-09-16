//
//  StorageManager.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.09.2023.
//

import SwiftUI

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
    
    func resave(title: String, colorOfImportant: Int, isPrivate: Bool, isDoneShowing: Bool, atIndex index: Int) {
        var lists = fetchData()
        lists[index].title = title
        lists[index].colorOfImportant = colorOfImportant
        lists[index].isPrivate = isPrivate
        lists[index].isDoneShowing = isDoneShowing
        
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
        var lists = fetchData()
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
    
    func deleteAll() {
        var lists = fetchData()
        lists = []
        
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func isNotificationAllowed() -> Bool {
        if userDefaults.data(forKey: "notification") != nil {
            return true
        } else {
            return false
        }
    }
    
    func setNotificationAllow() {
        userDefaults.set(true, forKey: "notification")
    }
}
