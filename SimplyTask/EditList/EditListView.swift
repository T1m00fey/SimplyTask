//
//  NewTaskView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

struct EditListView: View {
    let indexOfList: Int
    
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = EditListViewModel()
    
    @Binding var isScreenPresenting: Bool
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    init(indexOfList: Int, isScreenPresenting: Binding<Bool>) {
        self.indexOfList = indexOfList
        self._isScreenPresenting = isScreenPresenting
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
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
                   
                    Spacer()
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            if !viewModel.textFromTF.isEmpty {
                                listViewModel.lists[indexOfList].title = viewModel.textFromTF
                                listViewModel.lists[indexOfList].colorOfImportant = viewModel.getColorOfImportant()
                                listViewModel.lists[indexOfList].isPrivate = viewModel.isListPrivate
                            }
                        }
                        
                        isScreenPresenting.toggle()
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
                        .padding(.bottom, 80)
                    }
                    
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
            .navigationTitle("Редактировние списка")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                isFocused = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isScreenPresenting.toggle() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(uiColor: .label))
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
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
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.getLevelOfPrivate(listViewModel.lists[indexOfList].isPrivate)
            viewModel.getLevelOfImportant(listViewModel.lists[indexOfList].colorOfImportant)
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditListView(indexOfList: 0, isScreenPresenting: .constant(true))
            .environmentObject(ListViewModel())
    }
}
