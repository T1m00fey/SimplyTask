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
    
    @State private var text = ""
    @FocusState var isFocused: Bool
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    private let storageManager = StorageManager.shared
    private let notificationManager = NotificationManager.shared
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    init(navigationTitle: String, listIndex: Int, taskIndex: Int) {
        self.navigationTitle = navigationTitle
        self.listIndex = listIndex
        self.taskIndex = taskIndex
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        mediumFeedback.prepare()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    TextEditor(text: $text)
                        .frame(width: UIScreen.main.bounds.width - 32)
                        .frame(minHeight: isFocused ? 50 : UIScreen.main.bounds.height - 16)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                        .font(.system(size: 20))
                        .focused($isFocused)
                        .scrollContentBackground(.hidden)
                }
            }
            .onAppear {
                if navigationTitle == "Редактирование" {
                    text = listViewModel.lists[listIndex].tasks[taskIndex].title
                }
                
                isFocused = true
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if navigationTitle == "Новая задача" {
                            if text != "" && !text.isEmpty {
                                withAnimation {
                                    listViewModel.newTask(
                                        toList: listIndex,
                                        newTask: StructTask(
                                            title: text,
                                            isDone: false,
                                            notificationDate: nil,
                                            isNotificationDone: false,
                                            images: [],
                                            date: nil
                                        )
                                    )
                                    
                                    listViewModel.lists[listIndex].numberOfTasks += 1
                                }
                            }
                        } else if navigationTitle == "Редактирование" && !text.isEmpty {
                            let title = listViewModel.lists[listIndex].tasks[taskIndex].title
                            
                            withAnimation {
                                listViewModel.lists[listIndex].tasks[taskIndex].title = text
                            }
                            
                            let task = listViewModel.lists[listIndex].tasks[taskIndex]
                            
                            if task.notificationDate != nil && task.notificationDate ?? Date.now > Date.now {
                                notificationManager.scheduleNotification(text: task.title, date: task.notificationDate ?? Date.now)
                                
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(title)\(task.notificationDate ?? Date())"])
                            }
                        }
                        
                        mediumFeedback.impactOccurred()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .gesture(
                DragGesture()
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }

            )
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        
//            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden()
    }
}

struct EditSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EditSheetView(navigationTitle: "View", listIndex: 0, taskIndex: 0)
    }
}
