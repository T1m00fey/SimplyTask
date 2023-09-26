//
//  TasksListView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.07.2023.
//

import SwiftUI
import UserNotifications

struct TasksListView: View {
    let indexOfList: Int
    
    private let storageManager = StorageManager.shared
    private let notificationManager = NotificationManager.shared
    
    @StateObject var viewModel = TasksListViewModel()
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(indexOfList: Int) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        self.indexOfList = indexOfList
    }
    
    func move(from source: IndexSet, to destination: Int) {
        listViewModel.lists[indexOfList].tasks.move(fromOffsets: source, toOffset: destination)
        
        storageManager.newLists(lists: listViewModel.lists)
        
        listViewModel.reloadData()
    }
    
    func getNotificationsDone() {
        let date = Date.now
        
        let tasks = listViewModel.lists[indexOfList].tasks
        
        for index in 0..<tasks.count {
            if tasks[index].notificationDate != nil {
                if tasks[index].notificationDate ?? date <= date {
                    storageManager.toggleIsNotificationDone(taskIndex: index, listIndex: indexOfList)
                }
            }
        }
        
        listViewModel.reloadData()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                if listViewModel.isFaceIDSuccess {
                    ZStack {
                        VStack {
                            if !viewModel.isList && listViewModel.lists[indexOfList].tasks.count > 0 {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 15) {
                                        ForEach(0..<listViewModel.lists[indexOfList].tasks.count, id: \.self) { index in
                                            var task = listViewModel.lists[indexOfList].tasks[index]
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(Color(uiColor: .systemBackground))
                                                    .frame(width: 350)
                                                    .frame(minHeight: 50)
                                                    .shadow(radius: 3)
                                                
                                                Text(task.title)
                                                    .frame(
                                                        width: viewModel.isListEditing ? 120 : 230,
                                                        alignment: .leading
                                                    )
                                                    .padding(.leading, viewModel.isListEditing ? -90 : 20)
                                                    .padding(.top, 16)
                                                    .padding(.bottom, 16)
                                                    .padding(.trailing, !listViewModel.lists[indexOfList].isDoneShowing ? 80 : 16)
                                                    .foregroundColor(viewModel.getTitleOfTask(task.isDone))
                                                
                                                if listViewModel.lists[indexOfList].isDoneShowing {
                                                    Button {
                                                        storageManager.toggleIsDone(indexOfTask: index, indexOfList: indexOfList)
                                                        task.isDone.toggle()
                                                        
                                                        if !task.isDone {
                                                            storageManager.plusOneTask(atIndex: indexOfList)
                                                            
                                                            if listViewModel.lists[indexOfList].isMoveDoneToEnd {
                                                                storageManager.moveTaskToBegin(listIndex: indexOfList, taskIndex: index)
                                                            }
                                                        } else {
                                                            storageManager.deleteOneTask(atIndex: indexOfList)
                                                            storageManager.deleteDateInTask(taskIndex: index, listIndex: indexOfList)
                                                            
                                                            UNUserNotificationCenter.current().removePendingNotificationRequests(
                                                                withIdentifiers: [
                                                                    "\(listViewModel.lists[indexOfList].tasks[index].title)\(listViewModel.lists[indexOfList].tasks[index].notificationDate ?? Date())"
                                                                ]
                                                            )
                                                            
                                                            if listViewModel.lists[indexOfList].isMoveDoneToEnd {
                                                                storageManager.moveTaskToEnd(listIndex: indexOfList, taskIndex: index)
                                                            }
                                                        }
                                                        
                                                        if listViewModel.lists[indexOfList].numberOfTasks < 1 {
                                                            viewModel.isListEditing = false
                                                        }
                                                        
                                                        withAnimation {
                                                            listViewModel.reloadData()
                                                        }
                                                    } label: {
                                                        if task.isDone {
                                                            CheckmarkCircleView()
                                                        } else {
                                                            EmptyCircleView()
                                                        }
                                                    }
                                                    .padding(.trailing, 280)
                                                }
                                                
                                                if listViewModel.lists[indexOfList].tasks[index].notificationDate != nil && !viewModel.isListEditing {
                                                    Image(systemName: "bell")
                                                        .resizable()
                                                        .frame(width: 22, height: 22)
                                                        .padding(.leading, 280)
                                                        .foregroundColor(
                                                            listViewModel.lists[indexOfList].tasks[index].isNotificationDone ? .red : .gray
                                                        )
                                                }
                                                
                                                if viewModel.isListEditing {
                                                    if !listViewModel.lists[indexOfList].tasks[index].isDone {
                                                        Button {
                                                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                                                                if let error = error {
                                                                    print(error.localizedDescription)
                                                                } else {
                                                                    DispatchQueue.main.async {
                                                                        withAnimation {
                                                                            viewModel.isNotificationMenuShowing = true
                                                                            viewModel.selectedIndexForDelete = index
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } label: {
                                                            Image(systemName: "bell")
                                                                .resizable()
                                                                .frame(width: 22, height: 22)
                                                                .foregroundColor(Color(uiColor: .label))
                                                        }
                                                        .padding(.leading, 120)
                                                        
                                                        Button {
                                                            viewModel.isAlertForEditingPresenting.toggle()
                                                            viewModel.textFromEditAlert = listViewModel.lists[indexOfList].tasks[index].title
                                                            viewModel.selectedIndexForDelete = index
                                                        } label: {
                                                            Image(systemName: "square.and.pencil")
                                                                .resizable()
                                                                .frame(width: 22, height: 22)
                                                                .foregroundColor(Color(uiColor: .label))
                                                        }
                                                        .padding(.leading, 200)
                                                        .alert("Изменить задачу", isPresented: $viewModel.isAlertForEditingPresenting) {
                                                            TextField("", text: $viewModel.textFromEditAlert)
                                                            
                                                            Button("Изменить", role: .none) {
                                                                
                                                                let title = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete].title
                                                                
                                                                storageManager.editTask(indexOfList: indexOfList, indexOfTask: viewModel.selectedIndexForDelete, newTitle: viewModel.textFromEditAlert)

                                                                withAnimation {
                                                                    listViewModel.reloadData()
                                                                }

                                                                task = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete]
                                                                
                                                                if task.notificationDate != nil && task.notificationDate ?? Date.now > Date.now {
                                                                    notificationManager.scheduleNotification(text: task.title, date: task.notificationDate ?? Date.now)
                                                                    
                                                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(title)\(task.notificationDate ?? Date())"])
                                                                }
                                                                
                                                                viewModel.textFromEditAlert = ""
                                                            }
                                                            
                                                            Button("Отмена", role: .cancel) {
                                                                viewModel.textFromEditAlert = ""
                                                            }
                                                        }
                                                    }
                                                    
                                                    Button(action: {
                                                        viewModel.isAlertForDeletePresenting = true
                                                        viewModel.selectedIndexForDelete = index
                                                    }) {
                                                        Image(systemName: "minus.circle")
                                                            .resizable()
                                                            .frame(width: 23, height: 23)
                                                            .foregroundColor(.red)
                                                    }
                                                    .padding(.leading, 280)
                                                    .alert("Удалить задачу?", isPresented: $viewModel.isAlertForDeletePresenting) {
                                                        Button("Удалить", role: .destructive) {
                                                            task = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete]
                                                            
                                                            viewModel.isAlertForDeletePresenting.toggle()
                                                            
                                                            storageManager.deleteTask(atList: indexOfList, atIndex: viewModel.selectedIndexForDelete)
                                                            
                                                            if !task.isDone {
                                                                storageManager.deleteOneTask(atIndex: indexOfList)
                                                            }
                                                            
                                                            UNUserNotificationCenter.current().removePendingNotificationRequests(
                                                                withIdentifiers: ["\(listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete].title)\(listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete].notificationDate ?? Date())"]
                                                            )
                                                            
                                                            withAnimation {
                                                                listViewModel.reloadData()
                                                            }
                                                            
                                                            if listViewModel.lists[indexOfList].tasks.count < 1 {
                                                                viewModel.isListEditing.toggle()
                                                            }
                                                        }
                                                        
                                                        Button("Отмена", role: .cancel) {
                                                            viewModel.isAlertForDeletePresenting.toggle()
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
                                    ForEach(listViewModel.lists[indexOfList].tasks) { task in
                                        Text(task.title)
                                            .foregroundColor(task.isDone ? .gray : Color(uiColor: .label))
                                    }
                                    .onMove(perform: move)
                                }
                                .environment(\.editMode, .constant(viewModel.isList ? EditMode.active : EditMode.inactive))
                            } else if listViewModel.lists[indexOfList].tasks.count <= 0 {
                                VStack(spacing: 20) {
                                    Image(systemName: "tree")
                                        .resizable()
                                        .frame(width: 170, height: 170)
                                    
                                    Text("Создайте свою первую задачу!")
                                        .font(.system(size: 22))
                                        .bold()
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 170)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button(action: { viewModel.isAlertForNewTaskPresenting = true }) {
                                    Image(systemName: "plus.app.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.green)
                                        .padding(.leading, 20)
                                        .padding(.bottom, 15)
                                    
                                    Text("Новая задача")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 15)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                                .alert("Новая задача", isPresented: $viewModel.isAlertForNewTaskPresenting) {
                                    TextField("Название", text: $viewModel.textFromAlert)
                                    
                                    Button("Отмена", role: .cancel, action: {
                                        viewModel.isAlertForNewTaskPresenting.toggle()
                                        viewModel.textFromAlert = ""
                                    })
                                    
                                    Button("ОК", role: .none, action: {
                                        if !viewModel.textFromAlert.isEmpty {
                                            storageManager.newTask(
                                                toList: indexOfList, newTask: Task(
                                                    title: viewModel.textFromAlert,
                                                    isDone: false,
                                                    notificationDate: nil,
                                                    isNotificationDone: false
                                                )
                                            )
                                            storageManager.plusOneTask(atIndex: indexOfList)
                                        }
                                        
                                        withAnimation {
                                            listViewModel.reloadData()
                                        }
                                        
                                        viewModel.textFromAlert = ""
                                        viewModel.isAlertForNewTaskPresenting.toggle()
                                    })
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.isEditScreenPresenting.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 15)
                                        .padding(.trailing, 20)
                                }
                                .sheet(isPresented: $viewModel.isEditScreenPresenting) {
                                    EditListView(indexOfList: indexOfList, isScreenPresenting: $viewModel.isEditScreenPresenting)
                                }
                            }
                        }
                        
                        if viewModel.isNotificationMenuShowing {
                            NotificationView(isShowing: $viewModel.isNotificationMenuShowing, listIndex: indexOfList, taskIndex: viewModel.selectedIndexForDelete)
                                .environmentObject(ListViewModel())
                        }
                    }
                } else if listViewModel.isFaceIDError {
                    ErrorFaceIDView(indexOfList: indexOfList)
                }
            }
            .navigationBarTitle(listViewModel.lists[indexOfList].title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(uiColor: .label))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if listViewModel.lists[indexOfList].tasks.count > 0 {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    viewModel.isList.toggle()
                                }
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(viewModel.isList ? Color(uiColor: .label) : .gray)
                            }
                            
                            Button {
                                withAnimation {
                                    viewModel.isListEditing.toggle()
                                    listViewModel.reloadData()
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(viewModel.isListEditing ? Color(uiColor: .label) : .gray)
                            }

                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            listViewModel.requestBiometricUnlock(index: indexOfList)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            getNotificationsDone()
        }
        .onDisappear {
            listViewModel.isFaceIDSuccess = false
            listViewModel.isFaceIDError = false
            
            getNotificationsDone()
        }
    }
}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(indexOfList: 0)
            .environmentObject(ListViewModel())
    }
}

struct EmptyCircleView: View {
    var body: some View {
        Circle()
            .frame(width: 23, height: 23)
            .overlay(Circle().stroke(Color(uiColor: .label), lineWidth: 1))
            .foregroundColor(Color(uiColor: .systemBackground))
    }
}

struct CheckmarkCircleView: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 23, height: 23)
            .foregroundColor(.green)
            //.overlay(Circle().stroke(Color(uiColor: .label), lineWidth: 1))
    }
}
