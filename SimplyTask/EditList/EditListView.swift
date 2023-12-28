//
//  NewTaskView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

struct EditListView: View {
    @State private var image = ""
    
    let indexOfList: Int
    
    private let storageManager = StorageManager.shared
    private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = EditListViewModel()
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(indexOfList: Int) {
        self.indexOfList = indexOfList
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        softFeedback.prepare()
        mediumFeedback.prepare()
    }
    
    func getColorOfTF() -> Color {
        switch isFocused {
        case true:
            return Color(uiColor: .label)
        default:
            return .gray
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Название списка:")
                        .frame(width: 350, alignment: .bottomLeading)
                        .padding(.top, 50)
                        .font(.system(size: 20))
                    
                    TextField("Введите название", text: $viewModel.textFromTF)
                        .frame(width: 350, height: 30)
                        .font(.system(size: 25))
                        .tint(Color(uiColor: .label))
                        .focused($isFocused, equals: true)
                        .onAppear {
                            viewModel.textFromTF = listViewModel.lists[indexOfList].title
                        }
                            
                    Rectangle()
                        .frame(width: 350, height: 3)
                        .foregroundColor(getColorOfTF())
                        
                    Text("Уровень важности:")
                        .frame(width: 350, alignment: .bottomLeading)
                        .font(.system(size: 20))
                        .padding(.top, 50)
                    
                    HStack(spacing: 15) {
                        ForEach(0..<viewModel.levels.count, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .overlay(
                                        RoundedRectangle(
                                            cornerRadius: 7
                                        )
                                        .stroke(
                                            viewModel.colors[index], lineWidth: 2)
                                    )
                                    .frame(width: 75, height: 45, alignment: .bottom)
                                    .foregroundColor(Color(uiColor: .systemGray6))
                                
                                Text("\(viewModel.levels[index])")
                                    .foregroundColor(viewModel.selectedLevel == index ? Color(uiColor: .label) : .gray)
                                    .font(.system(size: 15))
                            }
                            .onTapGesture {  
                                viewModel.selectedLevel = index
                                viewModel.selectedColor = viewModel.colors[index]
                            }
                        }
                    }
                    
                    HStack {
                        Text("Индикатор Выполнено:")
                            .frame(width: 250, alignment: .bottomLeading)
                            .font(.system(size: 20))
                            .padding(.top, 50)
                            .offset(x: -50)
                            .padding(.leading, 30)
                            
                        
                        Button {
                            withAnimation {
                                viewModel.isDoneShowing.toggle()
                            }
                            softFeedback.impactOccurred()
                        } label: {
                            if viewModel.isDoneShowing {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 23, height: 23)
                                    .foregroundColor(.green)
                            } else {
                                Circle()
                                    .frame(width: 23, height: 23)
                                    .overlay(Circle().stroke(Color(uiColor: .label), lineWidth: 1))
                                    .foregroundColor(Color(uiColor: .systemGray6))
                            }
                        }
                        .offset(x: -70, y: 27)
                    }
                    
                    HStack {
                        Text("Перемещать выполненные задачи в конец:")
                            .frame(width: 250, alignment: .bottomLeading)
                            .font(.system(size: 20))
                            .foregroundColor(viewModel.isDoneShowing ? Color(uiColor: .label) : .gray)
                            .padding(.top, 30)
                            
                        Button {
                            withAnimation {
                                if viewModel.isDoneShowing {
                                    viewModel.isMoveDoneToEnd.toggle()
                                }
                            }
                            softFeedback.impactOccurred()
                        } label: {
                            if viewModel.isMoveDoneToEnd && viewModel.isDoneShowing {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 23, height: 23)
                                    .foregroundColor(.green)
                            } else {
                                Circle()
                                    .frame(width: 23, height: 23)
                                    .overlay(Circle().stroke(viewModel.isDoneShowing ? Color(uiColor: .label) : .gray, lineWidth: 1))
                                    .foregroundColor(Color(uiColor: .systemGray6))
                            }
                        }
                        .offset(x: 20, y: 15)
                        
                        Spacer()
                    }
                    .offset(x: 30)
                   
                    Spacer()
                    
                    Button(action: {
                        if !viewModel.textFromTF.isEmpty {
                            listViewModel.lists[indexOfList].title = viewModel.textFromTF
                            listViewModel.lists[indexOfList].colorOfImportant = viewModel.getNewColorOfImportant()
                            listViewModel.lists[indexOfList].isPrivate = viewModel.isListPrivate
                            listViewModel.lists[indexOfList].isDoneShowing = viewModel.isDoneShowing
                            listViewModel.lists[indexOfList].isMoveDoneToEnd = viewModel.isMoveDoneToEnd
                            
                            if image != "" {
                                listViewModel.lists[indexOfList].image = image
                            } else {
                                listViewModel.lists[indexOfList].image = nil
                            }
                        }
                        
                        mediumFeedback.impactOccurred()
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.square.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.green)
                            
                            Text("Готово")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        }
                    }
                    .sheet(isPresented: $viewModel.isImagesScreenPresenting) {
                        ImagesView(listIndex: indexOfList, isScreenPresenting: $viewModel.isImagesScreenPresenting, image: $image)
                    }
                    
                    Spacer()
                    
//                    Button {
//
//                    } label: {
//                        HStack {
//                            Spacer()
//
//                            Button {
//                                viewModel.isDeleteAlertPresenting.toggle()
//                            } label: {
//                                Image(systemName: "trash")
//                                    .resizable()
//                                    .frame(width: 25, height: 30)
//                                    .foregroundColor(.red)
//                                    .padding(.trailing, 20)
//                                    .padding(.bottom, 5)
//                            }
//                            .alert("Удалить список?", isPresented: $viewModel.isDeleteAlertPresenting) {
//                                Button("Отмена", role: .cancel) {
//                                    viewModel.isDeleteAlertPresenting.toggle()
//                                }
//
//                                Button("Удалить", role: .destructive) {
//                                    viewModel.isDeleteAlertPresenting.toggle()
//                                    //listViewModel.lists.remove(at: indexOfList)
//                                    activateRootLink = false
//                                }
//                            }
//                        }
//                    }
                }
            }
            .onAppear {
                viewModel.isDoneShowing = listViewModel.lists[indexOfList].isDoneShowing
                viewModel.isMoveDoneToEnd = listViewModel.lists[indexOfList].isMoveDoneToEnd
                
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            .navigationTitle("Редактировние списка")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                isFocused = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(uiColor: .label))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
//                        if storageManager.isPro() {
                            Button {
                                viewModel.isImagesScreenPresenting.toggle()
                            } label: {
                                if image != "" {
                                    Image(systemName: image)
                                } else {
                                    Image(systemName: "photo")
                                }
                            }
//                        }
                        
                        Button {
                            if viewModel.isListPrivate {
                                viewModel.isListPrivate.toggle()
                            } else {
                                listViewModel.requestBiometricUnlock {
                                    DispatchQueue.main.async {
                                        viewModel.isListPrivate.toggle()
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: viewModel.isListPrivate ? "lock" : "lock.open")
                                .foregroundColor(Color(uiColor: .label))
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .gesture(
            DragGesture()
                        .onEnded { value in
                            if value.translation.width > 50 {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }

        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.getLevelOfPrivate(listViewModel.lists[indexOfList].isPrivate)
            viewModel.getLevelOfImportant(listViewModel.lists[indexOfList].colorOfImportant)
            
//            if storageManager.isPro() {
                if listViewModel.lists[indexOfList].image != nil {
                    image = listViewModel.lists[indexOfList].image ?? "globe"
                }
//            }
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditListView(indexOfList: 0)
            .environmentObject(ListViewModel())
    }
}
