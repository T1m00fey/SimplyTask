//
//  GridView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI
import UserNotifications

struct GridView: View {
    
    @Binding var name: String
    
    private let storageManager = StorageManager.shared
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    @EnvironmentObject var viewModel: GridViewModel
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.scenePhase) var scenePhase
    
    init(name: Binding<String>) {
        self._name = name
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        mediumFeedback.prepare()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        listViewModel.lists.move(fromOffsets: source, toOffset: destination)
    }
    
    private func getDoneOfNotifications() {
        for listIndex in 0..<listViewModel.lists.count {
            for taskIndex in 0..<listViewModel.lists[listIndex].tasks.count {
                if listViewModel.lists[listIndex].tasks[taskIndex].notificationDate != nil {
                    if listViewModel.lists[listIndex].tasks[taskIndex].notificationDate ?? Date.now <= Date.now {
                        listViewModel.lists[listIndex].tasks[taskIndex].isNotificationDone = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    if !viewModel.isList && listViewModel.lists.count > 1 {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: viewModel.items, spacing: 15) {
                                ForEach(0..<listViewModel.lists.count, id: \.self) { indexOfList in
                                    NavigationLink(destination:TasksListView(indexOfList: indexOfList).environmentObject(TasksListViewModel())) {
                                        if listViewModel.lists[indexOfList].title != "" {
                                            GridRowView(index: indexOfList)
                                                .scaleEffect(0.97)
                                            .alert("Удалить список?", isPresented: $viewModel.isDeleteAlertPresenting) {
                                                Button("Отмена", role: .cancel) {
                                                    viewModel.isDeleteAlertPresenting.toggle()
                                                }
                                                
                                                Button("Удалить", role: .destructive) {
                                                    if listViewModel.lists[viewModel.selectedIndexForDelete].isPrivate && viewModel.isPrivateListPermitForDelete {
                                                        withAnimation {
                                                            listViewModel.lists.remove(at: viewModel.selectedIndexForDelete)
                                                            viewModel.isPrivateListPermitForDelete = false
                                                        }
                                                    } else {
                                                        withAnimation {
                                                            listViewModel.lists.remove(at: viewModel.selectedIndexForDelete)
                                                            viewModel.isPrivateListPermitForDelete = false
                                                        }
                                                    }
                                                    
                                                    if listViewModel.lists.count < 1 {
                                                        viewModel.isGridEditing = false
                                                    }
                                                    
                                                    viewModel.isDeleteAlertPresenting.toggle()
                                                    
                                                    mediumFeedback.impactOccurred()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    } else if viewModel.isList {
                        List {
                            ForEach(listViewModel.lists) { list in
                                if list.title != "" {
                                    HStack {
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(viewModel.getColorOfImportant(byNum: list.colorOfImportant))
                                        
                                        Text(list.title)
                                    }
                                }
                            }
                            .onMove(perform: move)
                            .listRowBackground(Color(uiColor: .systemBackground))
                        }
                        .environment(\.editMode, .constant(viewModel.isList ? EditMode.active : EditMode.inactive))
                        .scrollContentBackground(.hidden)
                    } else if listViewModel.lists.count <= 1 {
                        VStack(spacing: 20) {
                            Image(systemName: "tree")
                                .resizable()
                                .frame(width: 170, height: 170)
                            
                            Text("Создайте свой первый список!")
                                .font(.system(size: 22))
                                .bold()
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 170)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            viewModel.isAlertPresenting.toggle()
                            mediumFeedback.impactOccurred()
                        } label: {
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.green)
                                .padding(.leading, 20)
                                .padding(.bottom, 15)
                            
                            Text("Новый список")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.bottom, 15)
                        }
                        .alert("Новый список", isPresented: $viewModel.isAlertPresenting) {
                            TextField("Название", text: $viewModel.textFromAlert)
                            
                            Button("OK", role: .none) {
                                withAnimation {
                                    if listViewModel.lists.count == 0 {
                                        listViewModel.lists.append(
                                            TaskList(
                                                title: "",
                                                numberOfTasks: 0,
                                                colorOfImportant: 4,
                                                isPrivate: false,
                                                tasks: [],
                                                isDoneShowing: false,
                                                isMoveDoneToEnd: false
                                            )
                                        )
                                    }
                                    
                                    listViewModel.lists.removeLast()
                                    
                                    if viewModel.textFromAlert != "" {
                                        listViewModel.lists.append(
                                            TaskList(
                                                title: viewModel.textFromAlert,
                                                numberOfTasks: 0,
                                                colorOfImportant: 4,
                                                isPrivate: false,
                                                tasks: [],
                                                isDoneShowing: true,
                                                isMoveDoneToEnd: true
                                            )
                                        )
                                    }
                                    
                                    listViewModel.lists.append(
                                        TaskList(
                                            title: "",
                                            numberOfTasks: 0,
                                            colorOfImportant: 4,
                                            isPrivate: false,
                                            tasks: [],
                                            isDoneShowing: false,
                                            isMoveDoneToEnd: false
                                        )
                                    )
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
                        
                        Button {
                            viewModel.isSettingsScreenPresenting.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.gray)
                                .padding(.bottom, 15)
                                .padding(.trailing, 20)
                        }
                        .sheet(isPresented: $viewModel.isSettingsScreenPresenting) {
                            SettingsView(isScreenPresenting: $viewModel.isSettingsScreenPresenting)
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { scenePhase in
                switch scenePhase {
                case .background:
                    storageManager.newLists(lists: listViewModel.lists)
                case .inactive:
                    storageManager.newLists(lists: listViewModel.lists)
                default:
                    getDoneOfNotifications()
                }
            }
            .onAppear {
                if listViewModel.lists.count == 0 {
                    withAnimation {
                        listViewModel.reloadData()
                    }
                }
                
                getDoneOfNotifications()
                
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if listViewModel.lists.count > 1 {
                        HStack {
                            Button {
                                if !viewModel.isGridEditing {
                                    withAnimation {
                                        viewModel.isList.toggle()
                                    }
                                    softFeedback.impactOccurred()
                                }
                            } label: {
                                Image(systemName: "text.line.first.and.arrowtriangle.forward")
                                    .foregroundColor(viewModel.isList ? Color(uiColor: .label) : .gray)
                            }

                            Button {
                                if !viewModel.isList {
                                    withAnimation {
                                        viewModel.isGridEditing.toggle()
                                    }
                                    softFeedback.impactOccurred()
                                }
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(viewModel.isGridEditing ? .red : .gray)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: viewModel.getGreetingImage())
                            .foregroundColor(Color(uiColor: .label))
                        
                        Text("\(viewModel.getGreeting()), \(name)")
                    }
                    .onChange(of: viewModel.isSettingsScreenPresenting) { isPresenting in
                        if !isPresenting {
                            withAnimation {
                                name = storageManager.fetchName()
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(name: .constant("Name"))
            .environmentObject(GridViewModel())
            .environmentObject(ListViewModel())
    }
}
