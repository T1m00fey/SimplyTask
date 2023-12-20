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
    private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let generator = UINotificationFeedbackGenerator()
    
    @StateObject var viewModel = TasksListViewModel()
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(indexOfList: Int) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        self.indexOfList = indexOfList
        
        softFeedback.prepare()
        mediumFeedback.prepare()
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
        NavigationStack {
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
                                                
                                                VStack {
//                                                    if storageManager.isPro() {
                                                        if task.date != nil {
                                                            Text(viewModel.getStringDate(fromDate: task.date ?? Date.now))
                                                                .frame(width: 318, height: 30, alignment: .leading)
                                                                .foregroundColor(.gray)
                                                                .font(.system(size: 14))
                                                                .bold()
                                                                .padding(EdgeInsets(top: 16, leading: 16, bottom: -10, trailing: 16))
                                                        }
                                                        
                                                        if task.images.count > 0 {
                                                            let images = storageManager.getImage(fromList: indexOfList, fromTask: index)
                                                            
                                                            ForEach(0..<images.count , id: \.self) { imageIndex in
                                                                Image(uiImage: images[imageIndex])
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(maxWidth: 310)
                                                                    .cornerRadius(7.0)
                                                                    .padding(.top, 20)
                                                                    .padding(.leading, 20)
                                                                    .padding(.trailing, 20)
                                                                    .padding(.bottom, 10)
                                                                    .onTapGesture {
                                                                        viewModel.titleOfTask = task.title
                                                                        viewModel.image = images[imageIndex]
                                                                        viewModel.isDetailPhotoScreenPresenting.toggle()
                                                                    }
                                                            }
                                                        }
//                                                    }
                                                    
                                                    ZStack {
                                                        Text(task.title)
                                                            .frame(
                                                                width: viewModel.isListEditing ? 100 : 230,
                                                                alignment: .leading
                                                            )
                                                            .padding(.leading, viewModel.isListEditing ? -105 : 20)
                                                            .padding(.top, 16)
                                                            .padding(.bottom, 16)
                                                            .padding(.trailing, !listViewModel.lists[indexOfList].isDoneShowing ? 70 : 16)
                                                            .foregroundColor(
                                                                listViewModel.lists[indexOfList].isDoneShowing 
                                                                ? viewModel.getTitleOfTask(task.isDone)
                                                                : Color(uiColor: .label)
                                                            )
                                                        
                                                        if listViewModel.lists[indexOfList].isDoneShowing {
                                                            Button {
                                                                storageManager.toggleIsDone(indexOfTask: index, indexOfList: indexOfList)
                                                                task.isDone.toggle()
                                                                
                                                                if !task.isDone {
                                                                    mediumFeedback.impactOccurred()
                                                                    
                                                                    storageManager.plusOneTask(atIndex: indexOfList)
                                                                    
                                                                    if listViewModel.lists[indexOfList].isMoveDoneToEnd {
                                                                        storageManager.moveTaskToBegin(listIndex: indexOfList, taskIndex: index)
                                                                    }
                                                                } else {
                                                                    generator.notificationOccurred(.success)
                                                                    
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
                                                                
                                                                if task.isDone {
                                                                    viewModel.isAlertForDeletePresenting2.toggle()
                                                                    if listViewModel.lists[indexOfList].isMoveDoneToEnd {
                                                                        viewModel.selectedIndexForDelete = listViewModel.lists[indexOfList].tasks.count - 1
                                                                    } else {
                                                                        viewModel.selectedIndexForDelete = index
                                                                    }
                                                                }
                                                            } label: {
                                                                if task.isDone {
                                                                    CheckmarkCircleView()
                                                                } else {
                                                                    EmptyCircleView()
                                                                }
                                                            }
                                                            .padding(.trailing, 280)
                                                            
//                                                            .alert("Удалить задачу?", isPresented: $viewModel.isAlertForDeletePresenting2) {
//                                                                Button("Удалить", role: .destructive) {
//                                                                    task = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete]
//                                                                    
//                                                                    viewModel.isAlertForDeletePresenting2.toggle()
//                                                                    
//                                                                    storageManager.deleteTask(atList: indexOfList, atIndex: viewModel.selectedIndexForDelete)
//                                                                    
//                                                                    if !task.isDone {
//                                                                        storageManager.deleteOneTask(atIndex: indexOfList)
//                                                                    }
//                                                                    
//                                                                    if task.notificationDate != nil {
//                                                                        UNUserNotificationCenter.current().removePendingNotificationRequests(
//                                                                            withIdentifiers: ["\(task.title)\(task.notificationDate ?? Date())"]
//                                                                        )
//                                                                    }
//                                                                    
//                                                                    if task.images.count > 0 {
//                                                                        listViewModel.reloadData()
//                                                                    } else {
//                                                                        withAnimation {
//                                                                            listViewModel.reloadData()
//                                                                        }
//                                                                    }
//                                                                    
//                                                                    if listViewModel.lists[indexOfList].tasks.count < 1 {
//                                                                        viewModel.isListEditing.toggle()
//                                                                    }
//                                                                }
//                                                                
//                                                                Button("Отмена", role: .cancel) {
//                                                                    viewModel.isAlertForDeletePresenting2.toggle()
//                                                                }
//                                                            }
                                                        }
                                                        
                                                        if listViewModel.lists[indexOfList].isDoneShowing && !viewModel.isMenuShowing {
                                                            if listViewModel.lists[indexOfList].tasks[index].isDone {
                                                                Button(action: {
                                                                    viewModel.isAlertForDeletePresenting = true
                                                                    viewModel.selectedIndexForDelete = index
                                                                }) {
                                                                    Image(systemName: "minus.circle")
                                                                        .resizable()
                                                                        .frame(width: 23, height: 23)
                                                                        .foregroundColor(.gray)
                                                                }
                                                                .padding(.leading, 280)
                                                            }
                                                        }
                                                        
                                                        if viewModel.isMenuShowing {
                                                            Menu {
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
                                                                        Label("Уведомление", systemImage: "bell")
                                                                    }
                                                                    
                                                                    
                                                                    Button {
                                                                        viewModel.isRefactScreenPresenting.toggle()
                                                                        viewModel.textFromEditAlert = listViewModel.lists[indexOfList].tasks[index].title
                                                                        viewModel.selectedIndexForDelete = index
                                                                        viewModel.titleForEditScreen = "Редактирование"
                                                                    } label: {
                                                                        Label("Редактировать", systemImage: "square.and.pencil")
                                                                    }
                                                                    
                                                                    Button {
                                                                        withAnimation {
                                                                            viewModel.isDateMenuShowing.toggle()
                                                                            viewModel.selectedIndexForDelete = index
                                                                        }
                                                                    } label: {
                                                                        Label("Дата", systemImage: "calendar")
                                                                    }
                                                                    
                                                                    Button {
                                                                        viewModel.isPhotoScreenPresenting.toggle()
                                                                        viewModel.selectedIndexForDelete = index
                                                                    } label: {
                                                                        Label("Фото", systemImage: "photo")
                                                                    }
                                                                    
                                                                    Button {
                                                                        viewModel.selectedIndexForDelete = index
                                                                        viewModel.isListsScreenPresenting.toggle()
                                                                    } label: {
                                                                        Label("Перенести", systemImage: "arrowshape.turn.up.right")
                                                                    }

                                                                }
                                                                
                                                                Button {
                                                                    viewModel.isShareSheetPresenting.toggle()
                                                                    viewModel.selectedIndexForDelete = index
                                                                } label: {
                                                                    Label("Поделиться", systemImage: "square.and.arrow.up")
                                                                }
                                                                
                                                                Button {
                                                                    viewModel.isAlertForDeletePresenting = true
                                                                    viewModel.selectedIndexForDelete = index
                                                                } label: {
                                                                    Label("Удалить", systemImage: "minus.circle")
                                                                }
                                                            } label: {
                                                                Label("", systemImage: "ellipsis.circle")
                                                            }
                                                            .scaleEffect(1.3)
                                                            .padding(.leading, 290)
                                                        }
                                                        
                                                        if listViewModel.lists[indexOfList].tasks[index].notificationDate != nil && !viewModel.isMenuShowing {
                                                            Button {
                                                                withAnimation {
                                                                    viewModel.isNotificationMenuShowing = true
                                                                    viewModel.selectedIndexForDelete = index
                                                                    softFeedback.impactOccurred()
                                                                }
                                                            } label: {
                                                                Image(systemName: "bell")
                                                                    .resizable()
                                                                    .frame(width: 22, height: 22)
                                                                    .foregroundColor(
                                                                        listViewModel.lists[indexOfList].tasks[index].isNotificationDone ? .red : .gray
                                                                    )
                                                            }
                                                            .padding(.leading, 280)
                                                        }
                                                        
//                                                        if viewModel.isListEditing {
//                                                            if !listViewModel.lists[indexOfList].tasks[index].isDone {
//                                                                Button {
//                                                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
//                                                                        if let error = error {
//                                                                            print(error.localizedDescription)
//                                                                        } else {
//                                                                            DispatchQueue.main.async {
//                                                                                withAnimation {
//                                                                                    viewModel.isNotificationMenuShowing = true
//                                                                                    viewModel.selectedIndexForDelete = index
//                                                                                }
//                                                                            }
//                                                                        }
//                                                                    }
//                                                                } label: {
//                                                                    Image(systemName: "bell")
//                                                                        .resizable()
//                                                                        .frame(width: 22, height: 22)
//                                                                        .foregroundColor(Color(uiColor: .label))
//                                                                }
//                                                                .onChange(of: viewModel.isNotificationMenuShowing, perform: { isShowing in
//                                                                    if !isShowing {
//                                                                        listViewModel.reloadData()
//                                                                    }
//                                                                })
//                                                                
//                                                                .padding(.leading, 120)
//                                                                
//                                                                Button {
//                                                                    viewModel.isShareSheetPresenting.toggle()
//                                                                    viewModel.selectedIndexForDelete = index
//                                                                } label: {
//                                                                    Image(systemName: "square.and.arrow.up")
//                                                                        .resizable()
//                                                                        .frame(width: 20, height: 27)
//                                                                        .foregroundColor(Color(uiColor: .label))
//                                                                }
//                                                                .padding(.leading, 43)
//                                                                .sheet(isPresented: $viewModel.isShareSheetPresenting) {
//                                                                    ShareSheet(activityItems: [
//                                                                        """
//                                                                        \(listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete].title)
//                                                                        
//                                                                        # Sent from Simply Task
//                                                                        """
//                                                                    ])
//                                                                }
//                                                                
//
//                                                                
//                                                                Button {
//                                                                    viewModel.isAlertForEditingPresenting.toggle()
//                                                                    viewModel.textFromEditAlert = listViewModel.lists[indexOfList].tasks[index].title
//                                                                    viewModel.selectedIndexForDelete = index
//                                                                } label: {
//                                                                    Image(systemName: "square.and.pencil")
//                                                                        .resizable()
//                                                                        .frame(width: 22, height: 22)
//                                                                        .foregroundColor(Color(uiColor: .label))
//                                                                }
//                                                                .padding(.leading, 200)
////                                                                .sheet(isPresented: $viewModel.isAlertForEditingPresenting) {
////                                                                    EditSheetView(
////                                                                        isScreenPresenting: $viewModel.isAlertForEditingPresenting,
////                                                                        navigationTitle: "Редактирование",
////                                                                        listIndex: indexOfList,
////                                                                        taskIndex: viewModel.selectedIndexForDelete
////                                                                    )
////                                                                }
//                                                                
//                                                                if storageManager.isPro() {
//                                                                    Button {
//                                                                        viewModel.isPhotoScreenPresenting.toggle()
//                                                                        viewModel.selectedIndexForDelete = index
//                                                                    } label: {
//                                                                        Image(systemName: "photo")
//                                                                            .resizable()
//                                                                            .frame(width: 27, height: 22)
//                                                                            .foregroundColor(Color(uiColor: .label))
//                                                                    }
//                                                                    .padding(.leading, 280)
//                                                                    .padding(.top, 85)
//                                                                    .padding()
//                                                                    
//                                                                    Button {
//                                                                        withAnimation {
//                                                                            viewModel.isDateMenuShowing.toggle()
//                                                                            viewModel.selectedIndexForDelete = index
//                                                                        }
//                                                                    } label: {
//                                                                        Image(systemName: "calendar")
//                                                                            .resizable()
//                                                                            .frame(width: 27, height: 22)
//                                                                            .foregroundColor(Color(uiColor: .label))
//                                                                    }
//                                                                    .padding(.leading, 190)
//                                                                    .padding(.top, 85)
//                                                                    .padding()
//
//                                                                }
//
//                                                                //                                                        .alert("Изменить задачу", isPresented: $viewModel.isAlertForEditingPresenting) {
//                                                                //                                                            TextField("", text: $viewModel.textFromEditAlert)
//                                                                //
//                                                                //                                                            Button("Изменить", role: .none) {
//                                                                //
//                                                                //                                                                let title = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete].title
//                                                                //
//                                                                //                                                                storageManager.editTask(indexOfList: indexOfList, indexOfTask: viewModel.selectedIndexForDelete, newTitle: viewModel.textFromEditAlert)
//                                                                //
//                                                                //                                                                withAnimation {
//                                                                //                                                                    listViewModel.reloadData()
//                                                                //                                                                }
//                                                                //
//                                                                //                                                                task = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete]
//                                                                //
//                                                                //                                                                if task.notificationDate != nil && task.notificationDate ?? Date.now > Date.now {
//                                                                //                                                                    notificationManager.scheduleNotification(text: task.title, date: task.notificationDate ?? Date.now)
//                                                                //
//                                                                //                                                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(title)\(task.notificationDate ?? Date())"])
//                                                                //                                                                }
//                                                                //
//                                                                //                                                                viewModel.textFromEditAlert = ""
//                                                                //                                                            }
//                                                                //
//                                                                //                                                            Button("Отмена", role: .cancel) {
//                                                                //                                                                viewModel.textFromEditAlert = ""
//                                                                //                                                            }
//                                                                //                                                        }
//                                                            }
//                                                            
//                                                            Button(action: {
//                                                                viewModel.isAlertForDeletePresenting = true
//                                                                viewModel.selectedIndexForDelete = index
//                                                            }) {
//                                                                Image(systemName: "minus.circle")
//                                                                    .resizable()
//                                                                    .frame(width: 23, height: 23)
//                                                                    .foregroundColor(.red)
//                                                            }
//                                                            .padding(.leading, 280)
//                                                            .alert("Удалить задачу?", isPresented: $viewModel.isAlertForDeletePresenting) {
//                                                                Button("Удалить", role: .destructive) {
//                                                                    task = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete]
//                                                                    
//                                                                    viewModel.isAlertForDeletePresenting.toggle()
//                                                                    
//                                                                    storageManager.deleteTask(atList: indexOfList, atIndex: viewModel.selectedIndexForDelete)
//                                                                    
//                                                                    if !task.isDone {
//                                                                        storageManager.deleteOneTask(atIndex: indexOfList)
//                                                                    }
//                                                                    
//                                                                    if task.notificationDate != nil {
//                                                                        UNUserNotificationCenter.current().removePendingNotificationRequests(
//                                                                            withIdentifiers: ["\(task.title)\(task.notificationDate ?? Date())"]
//                                                                        )
//                                                                    }
//                                                                    
//                                                                    if task.images.count > 0 {
//                                                                        listViewModel.reloadData()
//                                                                    } else {
//                                                                        withAnimation {
//                                                                            listViewModel.reloadData()
//                                                                        }
//                                                                    }
//                                                                    
//                                                                    if listViewModel.lists[indexOfList].tasks.count < 1 {
//                                                                        viewModel.isListEditing.toggle()
//                                                                    }
//                                                                }
//                                                                
//                                                                Button("Отмена", role: .cancel) {
//                                                                    viewModel.isAlertForDeletePresenting.toggle()
//                                                                }
//                                                            }
//                                                        }
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
                                    .listRowBackground(Color(uiColor: .systemBackground))
                                }
                                .environment(\.editMode, .constant(viewModel.isList ? EditMode.active : EditMode.inactive))
                                .scrollContentBackground(.hidden)
                            } else if listViewModel.lists[indexOfList].tasks.count <= 0 {
                                VStack(spacing: 20) {
                                    Image(systemName: "tree")
                                        .resizable()
                                        .frame(width: 170, height: 170)
                                    
                                    Text("Запишите свою первую задачу!")
                                        .font(.system(size: 22))
                                        .bold()
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 170)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button {
                                    viewModel.isRefactScreenPresenting = true
                                    viewModel.titleForEditScreen = "Новая задача"
                                    
                                    mediumFeedback.impactOccurred()
                                } label: {
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
                                .sheet(isPresented: $viewModel.isListsScreenPresenting) {
                                    ListsView(
                                        listIndex: indexOfList,
                                        taskIndex: viewModel.selectedIndexForDelete,
                                        isScreenPresenting: $viewModel.isListsScreenPresenting
                                    )
                                }
                                .alert("Удалить задачу?", isPresented: $viewModel.isAlertForDeletePresenting) {
                                    Button("Удалить", role: .destructive) {
                                        let task = listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete]
                                        
                                        withAnimation {
                                            listViewModel.lists[indexOfList].tasks.remove(at: viewModel.selectedIndexForDelete)
                                            viewModel.isAlertForDeletePresenting.toggle()
                                        }
                                        
                                        
                                        if !task.isDone {
                                            storageManager.deleteOneTask(atIndex: indexOfList)
                                        }
                                        
                                        if task.notificationDate != nil {
                                            UNUserNotificationCenter.current().removePendingNotificationRequests(
                                                withIdentifiers: ["\(task.title)\(task.notificationDate ?? Date())"]
                                            )
                                        }
                                        
                                        storageManager.deleteTask(atList: indexOfList, atIndex: viewModel.selectedIndexForDelete)
                                        
                                        withAnimation {
                                            listViewModel.reloadData()
                                        }
                                    
                                        if listViewModel.lists[indexOfList].tasks.count < 1 {
                                            viewModel.isListEditing.toggle()
                                            viewModel.isMenuShowing = false
                                        }
                                        
                                        mediumFeedback.impactOccurred()
                                    }
                                    
                                    Button("Отмена", role: .cancel) {
                                        viewModel.isAlertForDeletePresenting.toggle()
                                    }
                                }
//                                .sheet(isPresented: $viewModel.isAlertForNewTaskPresenting) {
//                                    EditSheetView(
//                                        navigationTitle: "Новая задача",
//                                        listIndex: indexOfList,
//                                        taskIndex: 0
//                                    )
//                                    .environmentObject(ListViewModel())
//                                }
                                .sheet(isPresented: $viewModel.isShareSheetPresenting) {
                                    ShareSheet(activityItems: [
                                        """
                                        \(listViewModel.lists[indexOfList].tasks[viewModel.selectedIndexForDelete].title)
                                        
                                        # Sent from Simply Task
                                        """
                                    ])
                                }
                                .onChange(of: viewModel.isAlertForNewTaskPresenting) { isPresenting in
                                    if isPresenting == false {
                                        withAnimation {
                                            listViewModel.reloadData()
                                        }
                                    }
                                }
                                .sheet(isPresented: $viewModel.isPhotoScreenPresenting) {
                                    PhotoView(isScreenPresenting: $viewModel.isPhotoScreenPresenting, listIndex: indexOfList, taskIndex: viewModel.selectedIndexForDelete)
                                        .environmentObject(ListViewModel())
                                }
                                .navigationDestination(isPresented: $viewModel.isRefactScreenPresenting) {
                                    if viewModel.titleForEditScreen == "Редактирование" {
                                        EditSheetView(
                                            navigationTitle: "Редактирование",
                                           listIndex: indexOfList,
                                           taskIndex: viewModel.selectedIndexForDelete
                                       )
                                        .environmentObject(ListViewModel())
                                    } else {
                                        EditSheetView(
                                            navigationTitle: "Новая задача",
                                           listIndex: indexOfList,
                                           taskIndex: 0
                                       )
                                        .environmentObject(ListViewModel())
                                    }
                                }
                                .navigationDestination(isPresented: $viewModel.isDetailPhotoScreenPresenting) {
                                    DetailPhotoView(image: viewModel.image ?? UIImage(systemName: "xmark")!, title: viewModel.titleOfTask)
                                        .environmentObject(ListViewModel())
                                }
                                .navigationDestination(isPresented: $viewModel.isEditScreenPresenting) {
                                    EditListView(indexOfList: indexOfList)
                                }
//                                .sheet(isPresented: $viewModel.isDetailPhotoScreenPresenting) {
//                                    DetailPhotoView(
//                                        image: viewModel.image ?? UIImage(systemName: "xmark")!,
//                                        title: viewModel.titleOfTask,
//                                        isScreenPresenting: $viewModel.isDetailPhotoScreenPresenting
//                                    )
//                                }
//                                .alert("Новая задача", isPresented: $viewModel.isAlertForNewTaskPresenting) {
//                                    TextField("Название", text: $viewModel.textFromAlert)
//
//                                    Button("Отмена", role: .cancel, action: {
//                                        viewModel.isAlertForNewTaskPresenting.toggle()
//                                        viewModel.textFromAlert = ""
//                                    })
//
//                                    Button("ОК", role: .none, action: {
//                                        if !viewModel.textFromAlert.isEmpty {
//                                            storageManager.newTask(
//                                                toList: indexOfList, newTask: Task(
//                                                    title: viewModel.textFromAlert,
//                                                    isDone: false,
//                                                    notificationDate: nil,
//                                                    isNotificationDone: false
//                                                )
//                                            )
//                                            storageManager.plusOneTask(atIndex: indexOfList)
//                                        }
//
//                                        withAnimation {
//                                            listViewModel.reloadData()
//                                        }
//
//                                        viewModel.textFromAlert = ""
//                                        viewModel.isAlertForNewTaskPresenting.toggle()
//                                    })
//                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.isEditScreenPresenting.toggle()
                                    mediumFeedback.impactOccurred()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 15)
                                        .padding(.trailing, 20)
                                }
//                                .sheet(isPresented: $viewModel.isEditScreenPresenting) {
//                                    EditListView(indexOfList: indexOfList, isScreenPresenting: $viewModel.isEditScreenPresenting)
//                                }
                                
                            }
                        }
                        
                        if viewModel.isNotificationMenuShowing {
                            NotificationView(isShowing: $viewModel.isNotificationMenuShowing, listIndex: indexOfList, taskIndex: viewModel.selectedIndexForDelete)
                                .environmentObject(ListViewModel())
                        } else if viewModel.isDateMenuShowing {
                            DateView(isShowing: $viewModel.isDateMenuShowing, listIndex: indexOfList, taskIndex: viewModel.selectedIndexForDelete)
                        }
                    }
                } else if listViewModel.isFaceIDError {
                    ErrorFaceIDView(indexOfList: indexOfList)
                }
            }
            .onChange(of: viewModel.isNotificationMenuShowing, perform: { isShowing in
                if !isShowing {
                    listViewModel.reloadData()
                }
            })
            .gesture(
                DragGesture()
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }

            )
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
                                if !viewModel.isMenuShowing {
                                    withAnimation {
                                        viewModel.isList.toggle()
                                    }
                                    softFeedback.impactOccurred()
                                }
                            }) {
                                Image(systemName: "text.line.first.and.arrowtriangle.forward")
                                    .foregroundColor(viewModel.isList ? Color(uiColor: .label) : .gray)
                            }
                            
                            Button {
                                if !viewModel.isList {
                                    withAnimation {
                                        viewModel.isMenuShowing.toggle()
                                        listViewModel.reloadData()
                                    }
                                    softFeedback.impactOccurred()
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(viewModel.isMenuShowing ? Color(uiColor: .label) : .gray)
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
//
            UIApplication.shared.applicationIconBadgeNumber = 0
//
            getNotificationsDone()
            
            softFeedback.impactOccurred()
        }
        .onDisappear {
            listViewModel.isFaceIDSuccess = false
            listViewModel.isFaceIDError = false
            
//            getNotificationsDone()
        }
        .onChange(of: viewModel.isPhotoScreenPresenting) { newValue in
            if !newValue {
//                withAnimation {
                    listViewModel.reloadData()
//                }
            }
        }
        .onChange(of: viewModel.isDateMenuShowing) { isShowing in
            if !isShowing {
                withAnimation {
                    listViewModel.reloadData()
                }
            }
        }
        .onChange(of: viewModel.isRefactScreenPresenting) { isPresenting in
            if !isPresenting {
                withAnimation {
                    listViewModel.reloadData()
                }
            }
        }
        .onChange(of: viewModel.isListsScreenPresenting) { isPresenting in
            if !isPresenting {
                withAnimation {
                    listViewModel.reloadData()
                }
            }
        }
        
    }
}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(indexOfList: 0)
            .environmentObject(ListViewModel())
    }
}
