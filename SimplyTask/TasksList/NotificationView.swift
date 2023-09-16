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
    
    @State private var date = Date()
    @State private var isErrorAlertShowing = false
    @EnvironmentObject var listViewModel: ListViewModel
    
    @Binding var isShowing: Bool
    
    
    let listIndex: Int
    let taskIndex: Int
    
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
            .offset(x: 110, y: -110)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 60)
                .padding(.bottom, 90)
                .foregroundColor(Color(uiColor: .systemGray5))
            
            Image("Logo")
                .resizable()
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 5
                    ).stroke(
                        Color.white,
                        lineWidth: 3
                    )
                )
                .offset(x: -90, y: -45)
            
            Text("Simply Task")
                .font(.system(size: 13))
                .bold()
                .offset(x: -20, y: -55)
            
            Text(listViewModel.lists[listIndex].tasks[taskIndex].title)
                .font(.system(size: 13))
                .frame(width: 150, height: 10, alignment: .leading)
                .offset(x: 18, y: -35)
            
            DatePicker("", selection: $date, in: Date.now...)
                .frame(width: 80, height: 80)
                .padding(.top, 70)
            
            Button {
                if date.timeIntervalSinceNow > 0 {
                    notificationManager.scheduleNotification(
                        text: listViewModel.lists[listIndex].tasks[taskIndex].title,
                        index: taskIndex,
                        date: date
                    )
                } else {
                    isErrorAlertShowing = true
                }
                
                withAnimation {
                    isShowing.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 100, height: 30)
                        .foregroundColor(Color(uiColor: .systemGray5))
                        .opacity(0.7)
                    
                    Text("Готово")
                        .foregroundColor(Color(uiColor: .label))
                }
            }
            .padding(.top, 220)
            .alert("Ошибка", isPresented: $isErrorAlertShowing) {
                Text("Выберите другое время уведомления")
                
                Button("ОК", role: .cancel) {}
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(isShowing: .constant(true), listIndex: 0, taskIndex: 0)
            .environmentObject(ListViewModel())
    }
}
