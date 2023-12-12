//
//  ImagesView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 01.10.2023.
//

import SwiftUI

struct ImagesView: View {
    let listIndex: Int
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @Binding var isScreenPresenting: Bool
    @Binding var image: String
    
    private let items = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let storageManager = StorageManager.shared
    
    init(listIndex: Int, isScreenPresenting: Binding<Bool>, image: Binding<String>) {
        self.listIndex = listIndex
        self._isScreenPresenting = isScreenPresenting
        self._image = image
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: items, spacing: 55) {
                        ForEach(0..<listViewModel.images.count, id: \.self) { index in
                            Button {
                                image = listViewModel.images[index]
                                
                                isScreenPresenting.toggle()
                            } label: {
                                Image(systemName: listViewModel.images[index])
                                    .scaleEffect(2)
                            }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 30)
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
                        if image != "" {
                            Button {
                                image = ""
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                        }
                    }
                }
                .navigationTitle("Иконки")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(listIndex: 0, isScreenPresenting: .constant(true), image: .constant("globe"))
            .environmentObject(ListViewModel())
    }
}
