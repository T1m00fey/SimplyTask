//
//  EditSheetView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 29.09.2023.
//

import SwiftUI

struct EditSheetView: View {
    let listIndex: Int
    let taskIndex: Int
    let navigationTitle: String
    
    @Binding var isScreenPresenting: Bool
    
    @State private var text = ""
    @FocusState var isFocused: Bool
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private let storageManager = StorageManager.shared
    private let notificationManager = NotificationManager.shared
    
    init(isScreenPresenting: Binding<Bool>, navigationTitle: String, listIndex: Int, taskIndex: Int) {
        self._isScreenPresenting = isScreenPresenting
        self.navigationTitle = navigationTitle
        self.listIndex = listIndex
        self.taskIndex = taskIndex
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    Color(uiColor: .systemGray6)
                        .ignoresSafeArea()
                    
                    if colorScheme == .light {
                        TextEditor(text: $text)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                            .font(.system(size: 20))
                            .focused($isFocused)
                            .colorMultiply(Color(uiColor: .systemGray6))
                            .onTapGesture {
                                if navigationTitle == "Новая задача" {
                                    text = ""
                                }
                            }
                    } else {
                        TextEditor(text: $text)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                            .font(.system(size: 20))
                            .focused($isFocused)
                            .onTapGesture {
                                if navigationTitle == "Новая задача" {
                                    text = ""
                                }
                            }
                    }
                }
                .onAppear {
                    if navigationTitle == "Редактирование" {
                        text = listViewModel.lists[listIndex].tasks[taskIndex].title
                    } else {
                        text = "Введите название"
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isScreenPresenting.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if navigationTitle == "Новая задача" {
                                if text != "" && !text.isEmpty {
                                    storageManager.newTask(
                                        toList: listIndex,
                                        newTask: Task(title: text, isDone: false, notificationDate: nil, isNotificationDone: false)
                                    )
                                    
                                    storageManager.plusOneTask(atIndex: listIndex)
                                }
                            } else if navigationTitle == "Редактирование" {
                                let title = listViewModel.lists[listIndex].tasks[taskIndex].title
                                
                                storageManager.editTask(indexOfList: listIndex, indexOfTask: taskIndex, newTitle: text)
                                
                                withAnimation {
                                    listViewModel.reloadData()
                                }
                                
                                let task = listViewModel.lists[listIndex].tasks[taskIndex]
                                
                                if task.notificationDate != nil && task.notificationDate ?? Date.now > Date.now {
                                    notificationManager.scheduleNotification(text: task.title, date: task.notificationDate ?? Date.now)
                                    
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(title)\(task.notificationDate ?? Date())"])
                                }
                            }
                            
                            isScreenPresenting.toggle()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color(uiColor: .systemGray6))
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct EditSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EditSheetView(isScreenPresenting: .constant(true), navigationTitle: "View", listIndex: 0, taskIndex: 0)
    }
}
