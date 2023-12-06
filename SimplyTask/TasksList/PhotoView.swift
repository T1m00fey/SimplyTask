//
//  PhotoView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 01.10.2023.
//

import PhotosUI
import SwiftUI

struct PhotoView: View {
    let listIndex: Int
    let taskIndex: Int
    
    @State private var images = [UIImage(systemName: "bell")!] // <-- test image
    @State private var selectedIndexesForDelete: Int = 0
    @State private var avatarItem: PhotosPickerItem?
    @State private var isAlertPresenting = false
    @State private var isEditing = false
    @State private var selectedIndex = 0
    
    @Binding var isScreenPresenting: Bool
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    private let storageManager = StorageManager.shared
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    init(isScreenPresenting: Binding<Bool>, listIndex: Int, taskIndex: Int) {
        self._isScreenPresenting = isScreenPresenting
        self.listIndex = listIndex
        self.taskIndex = taskIndex
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        mediumFeedback.prepare()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    //                    if image != nil {
                    //                        Image(uiImage: image ?? UIImage(systemName: "bell")!)
                    //                            .resizable()
                    //                            .scaledToFit()
                    //                            .frame(minWidth: 310)
                    //                            .cornerRadius(7.0)
                    //                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    if isEditing {
                        HStack {
                            Spacer()
                            
                            Text("Нажмите на фото для удаления")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Spacer()
                        }
                    }
                    
                    if images.count > 0 {
                        ScrollView {
                            ForEach(0..<images.count, id: \.self) { imageIndex in
                                ZStack {
                                    Image(uiImage: images[imageIndex])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 310)
                                        .cornerRadius(7.0)
                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                        .shadow(radius: 3)
                                        .onTapGesture {
                                            if isEditing {
                                                isAlertPresenting.toggle()
                                                selectedIndex = imageIndex
                                            }
                                        }
                                        .alert("Удалить фото?", isPresented: $isAlertPresenting) {
                                            Button("Удалить", role: .destructive) {
                                                withAnimation {
                                                    images.remove(at: selectedIndex)
                                                    
                                                    if images.count == 0 {
                                                        isEditing = false
                                                    }
                                                }
                                            }
                                            
                                            Button("Отмена", role: .cancel) {
                                                
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    PhotosPicker(selection: $avatarItem, matching: .all(of: [.images])) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color(uiColor: .systemGray5))
                                .shadow(radius: 3)
                            
                            HStack {
                                Text("Выбрать фото")
                            }
                        }
                    }
                    
                    Spacer()
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isScreenPresenting.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        
                        Button {
                            
                            storageManager.addImage(toList: listIndex, andTask: taskIndex, photos: images)
                            
                            
                            isScreenPresenting.toggle()
                            
                            withAnimation {
                                listViewModel.reloadData()
                            }
                            
                            mediumFeedback.impactOccurred()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        
                        if images.count > 0 {
                            Button {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(isEditing ? .red : .gray)
                            }
                        }
                    }
                }
            }
            .onAppear {
                images = storageManager.getImage(fromList: listIndex, fromTask: taskIndex)
            }
            .onChange(of: avatarItem) { _ in
                Task {
                    if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            withAnimation {
                                images.append(uiImage)
                            }
                            return
                        }
                    }
                    
                    print("Failed")
                }
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(isScreenPresenting: .constant(true), listIndex: 0, taskIndex: 0)
            .environmentObject(ListViewModel())
    }
}
