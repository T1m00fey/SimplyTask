//
//  ListsView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 20.12.2023.
//

import SwiftUI

struct ListsView: View {
    let listIndex: Int
    let taskIndex: Int
    
    @State private var lists: [TaskList] = []
    
    @Binding var isScreenPresenting: Bool
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    private let storageManager = StorageManager.shared
    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    
    private func getColorOfImportant(byNum num: Int) -> Color {
        switch num {
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .red
        default:
            return .gray
        }
    }
    
    init(listIndex: Int, taskIndex: Int, isScreenPresenting: Binding<Bool>) {
        self.listIndex = listIndex
        self.taskIndex = taskIndex
        self._isScreenPresenting = isScreenPresenting
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                List {
                    ForEach(0..<lists.count, id: \.self) { index in
                        if lists[index].title != "" {
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(getColorOfImportant(byNum: lists[index].colorOfImportant))
                                
                                Text(lists[index].title)
                                
                                Spacer()
                            }
                            .onTapGesture {
                                let task = lists[listIndex].tasks[taskIndex]
                                lists[index].tasks.append(task)
                                lists[listIndex].tasks.remove(at: taskIndex)
                                
                                lists[index].numberOfTasks += 1
                                lists[listIndex].numberOfTasks -= 1
                                
                                storageManager.newLists(lists: lists)
                                
                                lightFeedback.impactOccurred()
                                
                                isScreenPresenting.toggle()
                            }
                        }
                    }
                    .listRowBackground(Color(uiColor: .systemBackground))
                }
            }
            .onAppear {
                lists = listViewModel.lists
                
                lightFeedback.prepare()
            }
            .navigationTitle("Списки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isScreenPresenting.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color(uiColor: .label))
                    }
                }
            }
        }
    }
}

#Preview {
    ListsView(listIndex: 0, taskIndex: 0, isScreenPresenting: .constant(true))
        .environmentObject(ListViewModel())
}
