//
//  DateView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 16.10.2023.
//

import SwiftUI

struct DateView: View {
    private let storageManager = StorageManager.shared
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @Binding var isShowing: Bool
    
    @State private var date = Date.now
    @State private var isAlertShowing = false
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    let listIndex: Int
    let taskIndex: Int
    
    init(isShowing: Binding<Bool>, listIndex: Int, taskIndex: Int) {
        self._isShowing = isShowing
        self.listIndex = listIndex
        self.taskIndex = taskIndex
        
        mediumFeedback.prepare()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 290, height: 230)
                .foregroundColor(Color(uiColor: .systemBackground))
                .shadow(radius: 5)
            
            Button {
                withAnimation {
                    isShowing.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color(uiColor: .label))
            }
            .offset(x: 107, y: -75)
            
            DatePicker("", selection: $date, displayedComponents: [.date])
                .frame(width: 80, height: 80)
                .padding(.bottom, 60)
            
            Button {
                withAnimation {
                    listViewModel.lists[listIndex].tasks[taskIndex].date = date
                    isShowing.toggle()
                }
                
                mediumFeedback.impactOccurred()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 100, height: 30)
                        .foregroundColor(Color(uiColor: .systemGray5))
                        .opacity(0.7)
                    
                    Text("Записать")
                }
            }
            .padding(.top, 80)
            
            if listViewModel.lists[listIndex].tasks[taskIndex].date != nil {
                Button("Удалить дату") {
                    withAnimation {
    //                    isShowing.toggle()
                        isAlertShowing.toggle()
                    }
                }
                .foregroundColor(.red)
                .padding(.top, 170)
                .alert("Удалить дату?", isPresented: $isAlertShowing) {
                    Button("Удалить", role: .destructive) {
                        withAnimation {
                            isShowing.toggle()
                            isAlertShowing = false
                            listViewModel.lists[listIndex].tasks[taskIndex].date = nil
                        }
                    }
                    
                    Button("Отмена", role: .cancel) {
                        isAlertShowing.toggle()
                    }
                }
            }
        }
        .onAppear {
            date = listViewModel.lists[listIndex].tasks[taskIndex].date ?? Date.now
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(isShowing: .constant(true), listIndex: 0, taskIndex: 0)
    }
}
