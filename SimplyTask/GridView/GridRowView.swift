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
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 170, height: 170)
                .foregroundColor(Color(uiColor: .systemBackground))
                .shadow(radius: 3)
                //.padding(.bottom, 1)
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(gridViewModel.getColorOfImportant(byNum: listViewModel.lists[index].colorOfImportant))
                .offset(x: 60, y: -50)
            
            if listViewModel.lists[index].isPrivate && !gridViewModel.isGridEditing {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 17, height: 25)
                    .offset(x: -55, y: -49)
                    .foregroundColor(Color(uiColor: .label))
            }
            
            if gridViewModel.isGridEditing {
                Button {
                    gridViewModel.isDeleteAlertPresenting.toggle()
                    gridViewModel.selectedIndexForDelete = index
                } label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                .alert("Удалить список?", isPresented: $gridViewModel.isDeleteAlertPresenting) {
                    Button("Отмена", role: .cancel) {
                        gridViewModel.isDeleteAlertPresenting.toggle()
                    }
                    
                    Button("Удалить", role: .destructive) {
                        gridViewModel.isDeleteAlertPresenting.toggle()
                        
                        if listViewModel.lists[index].isPrivate {
                            listViewModel.requestBiometricUnlock {
                                DispatchQueue.main.async {
                                    storageManager.deleteList(atIndex: gridViewModel.selectedIndexForDelete)
                                    
                                    listViewModel.reloadData()
                                }
                            }
                        } else {
                            storageManager.deleteList(atIndex: gridViewModel.selectedIndexForDelete)
                            
                            listViewModel.reloadData()
                        }
                        
                        if listViewModel.lists.count <= 1 {
                            gridViewModel.isGridEditing = false
                        }
                        
                        print(listViewModel.lists)
                    }
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
                .frame(width: 140, height: 25, alignment: .bottomLeading)
                .padding(.top, 110)
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
