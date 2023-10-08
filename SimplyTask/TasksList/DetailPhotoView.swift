//
//  DetailPhotoView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 02.10.2023.
//

import SwiftUI

struct DetailPhotoView: View {
    @State private var scale: CGFloat = 1.0
    @State private var position = CGSize.zero
    @GestureState private var dragState = CGSize.zero
    
    @Binding var isScreenPresenting: Bool
    
    let image: UIImage
    let title: String

    
    init(image: UIImage, title: String, isScreenPresenting: Binding<Bool>) {
        self.image = image
        self.title = title
        self._isScreenPresenting = isScreenPresenting
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isScreenPresenting.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct DetailPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPhotoView(image: UIImage(systemName: "bell")!, title: "Title", isScreenPresenting: .constant(true))
    }
}
