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
        
        storageManager.newLists(lists: listViewModel.lists)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    if listViewModel.lists.count > 1 && !viewModel.isList {
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
                                                    viewModel.isDeleteAlertPresenting.toggle()
                                                    
                                                    if listViewModel.lists[indexOfList].isPrivate && viewModel.isPrivateListPermitForDelete {
                                                        storageManager.deleteList(atIndex: viewModel.selectedIndexForDelete)
                                                        viewModel.isPrivateListPermitForDelete = false
                                                    } else {
                                                        storageManager.deleteList(atIndex: viewModel.selectedIndexForDelete)
                                                    }
                                                    
                                                    if listViewModel.lists.count <= 1 {
                                                        viewModel.isGridEditing = false
                                                    }
                                                    
                                                    withAnimation {
                                                        listViewModel.reloadData()
                                                    }
                                                    
                                                    mediumFeedback.impactOccurred()
                                                }
                                            }
                                            .onChange(of: scenePhase) { scenePhase in
                                                if scenePhase == .active {
                                                    storageManager.getDoneOfNotifications()
                                                    withAnimation {
                                                        listViewModel.reloadData()
                                                    }
                                                } else if scenePhase == .background {
                                                    withAnimation {
                                                        listViewModel.reloadData()
                                                    }
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
                        }
                        .environment(\.editMode, .constant(viewModel.isList ? EditMode.active : EditMode.inactive))
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
                        Button(action: { viewModel.isAlertPresenting.toggle() }) {
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
                                if viewModel.textFromAlert != "" {
                                    if listViewModel.lists.count == 0 {
                                        storageManager.new(list: TaskList(title: "", numberOfTasks: 0, colorOfImportant: 4, isPrivate: false, tasks: [], isDoneShowing: false, isMoveDoneToEnd: false))
                                    }
                                    
                                    storageManager.deleteLastList()
                                    
                                    storageManager.new(
                                        list: TaskList(
                                            title: viewModel.textFromAlert,
                                            numberOfTasks: 0,
                                            colorOfImportant: 4,
                                            isPrivate: false,
                                            tasks: [],
                                            isDoneShowing: true,
                                            isMoveDoneToEnd: true
                                        )
                                    )
                                    
                                    storageManager.new(list: TaskList(title: "", numberOfTasks: 0, colorOfImportant: 4, isPrivate: false, tasks: [], isDoneShowing: false, isMoveDoneToEnd: false))
                                    
                                    withAnimation {
                                        listViewModel.reloadData()
                                    }
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
            .onAppear {
//                listViewModel.reloadData()
                
                if !storageManager.isPro() {
                    storageManager.getPro()
                }
                
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
