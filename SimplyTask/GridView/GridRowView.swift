//
//  GridRowView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

struct GridRowView: View {
    let index: Int
    
    private let storageManager = StorageManager.shared
    
    @EnvironmentObject var gridViewModel: GridViewModel
    @EnvironmentObject var listViewModel: ListViewModel
    
    init(index: Int) {
        self.index = index
    }
    
    func getIsDoneNotification() -> Bool {
        var result = false
        
        listViewModel.lists[index].tasks.forEach { task in
            if task.isNotificationDone {
                result = true
            }
        }
        
        return result
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 170, height: 170)
                .foregroundColor(Color(uiColor: .systemBackground))
                .shadow(radius: 3)
            
            if !storageManager.isPro() {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(gridViewModel.getColorOfImportant(byNum: listViewModel.lists[index].colorOfImportant))
                    .offset(x: 60, y: -50)
            }
                
            if storageManager.isPro() && listViewModel.lists[index].image != nil && !gridViewModel.isGridEditing {
                Image(systemName: listViewModel.lists[index].image ?? "globe")
                .scaleEffect(1.5).offset(x: -55, y: -49)
            }
            
            if !storageManager.isPro() && listViewModel.lists[index].isPrivate && !gridViewModel.isGridEditing {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 17, height: 25)
                    .offset(x: -55, y: -49)
                    .foregroundColor(Color(uiColor: .label))
            } else if listViewModel.lists[index].image == nil && listViewModel.lists[index].isPrivate && !gridViewModel.isGridEditing {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 17, height: 25)
                    .offset(x: -55, y: -49)
                    .foregroundColor(Color(uiColor: .label))
            }
            
            if listViewModel.lists[index].isPrivate && storageManager.isPro() && listViewModel.lists[index].image != nil {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 17, height: 25)
                    .offset(x: 55, y: -49)
                    .foregroundColor(gridViewModel.getColorOfImportant(byNum: listViewModel.lists[index].colorOfImportant))
            } else {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(gridViewModel.getColorOfImportant(byNum: listViewModel.lists[index].colorOfImportant))
                    .offset(x: 60, y: -50)
            }
            
            if getIsDoneNotification() {
                Image(systemName: "bell")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                    .offset(x: 60, y: 57)
            }
            
            if gridViewModel.isGridEditing {
                Button {
                    gridViewModel.selectedIndexForDelete = index
                    
                    if listViewModel.lists[index].isPrivate {
                        listViewModel.requestBiometricUnlock {
                            DispatchQueue.main.async {
                                gridViewModel.isPrivateListPermitForDelete = true
                                gridViewModel.isDeleteAlertPresenting.toggle()
                            }
                        }
                    } else {
                        gridViewModel.isDeleteAlertPresenting.toggle()
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                .offset(x: -53, y: -47)
            }
            
            Text(listViewModel.lists[index].title)
                .frame(width: 140, height: 30, alignment: .leading)
                .padding(.top, 57)
//                .frame(width: 140, height: 30)
//                .offset(x: -2, y: 30)
                .font(.system(size: 18))
                .foregroundColor(Color(uiColor: .label))
            
            Text("Задач: \(listViewModel.lists[index].numberOfTasks)")
                .foregroundColor(.gray)
                .font(.headline)
                .frame(width: 110, height: 25, alignment: .bottomLeading)
//                .background(Color.yellow)
                .padding(.top, 110)
                .padding(.trailing, 30)
        }
    }
}

struct GridRowView_Previews: PreviewProvider {
    static var previews: some View {
        GridRowView(index: 0)
            .environmentObject(ListViewModel())
            .environmentObject(GridViewModel())
    }
}
