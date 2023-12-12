//
//  StartView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.09.2023.
//

import SwiftUI

struct StartView: View {
    @State private var text = ""
    
    @FocusState private var isFocused: Bool
    
    private let storageManager = StorageManager.shared
    
    func getColorOfTF() -> Color {
        if isFocused {
            return Color(uiColor: .label)
        } else if !isFocused {
            return .gray
        } else {
            return .red
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Добро пожаловать!")
                            .font(.title)
                            .padding()
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    
                    VStack {
                        TextField("Ваше имя", text: $text)
                            .font(.system(size: 25))
                            .frame(width: 250, height: 30)
                            .focused($isFocused, equals: true)
                            .multilineTextAlignment(.center)
                        
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 250, height: 3)
                            .foregroundColor(getColorOfTF())
                    }
                    .padding(.top, 60)
                    
                    if text != "" && !text.isEmpty {
                        NavigationLink(destination: GridView(name: $text).environmentObject(ListViewModel()).environmentObject(GridViewModel())) {
                            HStack {
                                Text("Начать")
                                    .font(.system(size: 25))

                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                        }
                        .padding(.top, 170)
                        .padding(.leading, 16)
                    } else {
                        HStack {
                            Text("Начать")
                                .font(.system(size: 25))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 170)
                        .padding(.leading, 16)
                    }
                    
                    Spacer()
                }
            }
            .onTapGesture {
                isFocused = false
            }
            .onDisappear {
                storageManager.save(name: text)
                
//                if text == "givePremium123" {
                storageManager.getPro()
//                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
