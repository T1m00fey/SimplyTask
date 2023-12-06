//
//  DetailPhotoView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 02.10.2023.
//

import SwiftUI

struct DetailPhotoView: View {
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = CGSize.zero
    
    @Environment(\.presentationMode) var presentationMode
    
    let image: UIImage
    let title: String
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                                    .onEnded { value in
                                        if value.translation.width > 50 {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }

                    )
                
                
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 4
                                
                            }
                        } else {
                            withAnimation(.spring()){
                                imageScale = 1
                                imageOffset = .zero
                            }
                        }
                    }
                    .gesture(DragGesture()
                        .onChanged{ value in
                            withAnimation(.linear(duration: 0.2)){
                                if imageScale <= 1  {
                                    imageOffset = value.translation
                                }else{
                                    imageOffset = value.translation

                                }
                                
                               
                            }
                        }
                        .onEnded{ value in
                            if imageScale <= 1 {
                                withAnimation(.spring()){
                                    imageScale = 1
                                    imageOffset = .zero
                                }
                            }
                        }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 0.2)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded{ _ in
                                
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    withAnimation(.spring()){
                                        imageScale = 1
                                        imageOffset = .zero
                                    }
                                }
                            }
                                      
                    
                    )
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct DetailPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPhotoView(image: UIImage(systemName: "bell")!, title: "Title")
    }
}
