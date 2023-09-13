//
//  GridView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

struct GridView: View {
    private let storageManager = StorageManager.shared
    
    @EnvironmentObject var viewModel: GridViewModel
    @EnvironmentObject var listViewModel: ListViewModel

    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    if listViewModel.lists.count > 1 {
                        ScrollView {
                            LazyVGrid(columns: viewModel.items, spacing: 15) {
                                ForEach(0..<listViewModel.lists.count - 1, id: \.self) { index in
                                    NavigationLink(destination: TasksListView(indexOfList: index)) {
                                        if listViewModel.lists[index].title != "" {
                                            GridRowView(index: index)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: { viewModel.isAlertPresenting.toggle() }) {
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.green)
                                .padding(.leading, 20)
                                .padding(.bottom, 5)
                            
                            Text("Новый список")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                        }
                        .alert("Новый список", isPresented: $viewModel.isAlertPresenting) {
                            TextField("Название", text: $viewModel.textFromAlert)
                            
                            Button("OK", role: .none) {
                                if viewModel.textFromAlert != "" {
                                    if listViewModel.lists.count == 0{
                                        storageManager.new(list: TaskList(title: "", numberOfTasks: 0, colorOfImportant: 4, isPrivate: false, tasks: []))
                                    }
                                    
                                    storageManager.deleteLastList()
                                    
                                    storageManager.new(
                                        list: TaskList(
                                            title: viewModel.textFromAlert,
                                            numberOfTasks: 0,
                                            colorOfImportant: 4,
                                            isPrivate: false,
                                            tasks: []
                                        )
                                    )
                                    
                                    storageManager.new(list: TaskList(title: "", numberOfTasks: 0, colorOfImportant: 4, isPrivate: false, tasks: []))
                                    
                                    listViewModel.reloadData()
                                    
                                    print(listViewModel.lists)
                                }
                                
                                viewModel.isAlertPresenting.toggle()
                                viewModel.textFromAlert = ""
                            }
                            
                            Button("Отмена", role: .cancel) {
                                viewModel.isAlertPresenting.toggle()
                                viewModel.textFromAlert = ""
                            }
                        }
                        
                        Spacer()
                        
//                        Button {
//                            viewModel.isSettingsScreenPresenting.toggle()
//                        } label: {
//                            Image(systemName: "gearshape.fill")
//                                .resizable()
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(.gray)
//                                .padding(.bottom, 5)
//                                .padding(.trailing, 20)
//                        }
//                        .sheet(isPresented: $viewModel.isSettingsScreenPresenting) {
//                            SettingsView(isScreenPresenting: $viewModel.isSettingsScreenPresenting)
//                                .environmentObject(ThemesViewModel())
//                        }
                    }
                }
            }
            .onAppear {
                //storageManager.deleteAll()
                
                print(listViewModel.lists)
            }
            .navigationTitle(viewModel.getWeekday())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if listViewModel.lists.count > 1 {
                        Button {
                            withAnimation {
                                viewModel.isGridEditing.toggle()
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(viewModel.isGridEditing ? .red : .gray)
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
            .environmentObject(GridViewModel())
            .environmentObject(ListViewModel())
    }
}
