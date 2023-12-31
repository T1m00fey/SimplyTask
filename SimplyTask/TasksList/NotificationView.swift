//
//  NotificationView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.09.2023.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    private let notificationManager = NotificationManager.shared
    private let storageManager = StorageManager.shared
    
    @State private var date = Date.now
    @State private var isErrorAlertShowing = false
    @State private var isDeleteAlertShowing = false
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @Binding var isShowing: Bool
    
    let listIndex: Int
    let taskIndex: Int
    
    func getDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 290, height: 320)
                .foregroundColor(Color(uiColor: .systemBackground))
                .shadow(radius: 5)
            
            Button {
                withAnimation {
                    isShowing = false
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color(uiColor: .label))
            }
            .offset(x: 110, y: -120)
            
            if listViewModel.lists[listIndex].tasks[taskIndex].notificationDate != nil {
                VStack {
                    HStack {
                        Image(systemName: "bell")
                        
                        Text("Записано на:")
                    }
                    
                    Text(getDate(listViewModel.lists[listIndex].tasks[taskIndex].notificationDate ?? Date.now))
                        .offset(x: 0, y: 10)
                        .foregroundColor(listViewModel.lists[listIndex].tasks[taskIndex].isNotificationDone ? .red : Color(uiColor: .label))
                }
                .offset(x: -60, y: -125)
            }
            
//            RoundedRectangle(cornerRadius: 10)
//                .frame(width: 250, height: 60)
//                .padding(.bottom, 70)
//                .foregroundColor(Color(uiColor: .systemGray5))
//
//            Image("Logo")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .overlay(
//                    RoundedRectangle(
//                        cornerRadius: 5
//                    ).stroke(
//                        Color.white,
//                        lineWidth: 3
//                    )
//                )
//                .offset(x: -90, y: -35)
//
//            Text("Simply Task")
//                .font(.system(size: 13))
//                .bold()
//                .offset(x: -20, y: -47)
            
            Text("Задача:")
                .font(.system(size: 17))
                .bold()
                .offset(x: -90, y: -60)
            
            Text(listViewModel.lists[listIndex].tasks[taskIndex].title)
                .font(.system(size: 15))
                .frame(width: 230, height: 40, alignment: .topLeading)
                .offset(x: -7, y: -25)
            
            DatePicker("", selection: $date, in: Date.now...)
                .frame(width: 80, height: 80)
                .padding(.top, 70)
            
            Button {
                if date.timeIntervalSinceNow >= 0 {
                    notificationManager.scheduleNotification(
                        text: listViewModel.lists[listIndex].tasks[taskIndex].title,
                        date: date
                    )
                    
                    if listViewModel.lists[listIndex].tasks[taskIndex].notificationDate != nil {
                        let task = listViewModel.lists[listIndex].tasks[taskIndex]
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(task.title)\(task.notificationDate ?? Date())"])
                    }
                    
                    storageManager.addDateToTask(taskIndex: taskIndex, listIndex: listIndex, date: date)
                    
                } else {
                    isShowing = false
                    isErrorAlertShowing = true
                }
                
                withAnimation {
                    isShowing.toggle()
                    listViewModel.reloadData()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 100, height: 30)
                        .foregroundColor(Color(uiColor: .systemGray5))
                        .opacity(0.7)
                    
                    Text(listViewModel.lists[listIndex].tasks[taskIndex].notificationDate == nil ? "Уведомить" : "Изменить")
                        .foregroundColor(Color(uiColor: .label))
                }
            }
            .padding(.top, 180)
            .alert("Ошибка", isPresented: $isErrorAlertShowing) {
                Button("ОК") {}
            } message: {
                Text("Попробуйте изменить время")
            }

            
            if listViewModel.lists[listIndex].tasks[taskIndex].notificationDate != nil {
                Button("Удалить уведомление") {
                    isDeleteAlertShowing.toggle()
                }
                .foregroundColor(Color.red)
                .offset(y: 135)
                .alert("Удалить уведомление?", isPresented: $isDeleteAlertShowing) {
                    Button("Отмена", role: .cancel) {}
                    
                    Button("Удалить", role: .destructive) {
                        storageManager.deleteDateInTask(taskIndex: taskIndex, listIndex: listIndex)
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(
                            withIdentifiers: [
                                "\(listViewModel.lists[listIndex].tasks[taskIndex].title)\(listViewModel.lists[listIndex].tasks[taskIndex].notificationDate ?? Date())"
                            ]
                        )
                        
                        withAnimation {
                            isShowing.toggle()
                            listViewModel.reloadData()
                        }
                    }
                }
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(isShowing: .constant(true), listIndex: 0, taskIndex: 1)
            .environmentObject(ListViewModel())
    }
}
