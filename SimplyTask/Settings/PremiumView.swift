//
//  PremiumView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 01.10.2023.
//

import SwiftUI

struct PremiumView: View {
    @Binding var isScreenPresenting: Bool
    
    private let storageManager = StorageManager.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    init(isScreenPresenting: Binding<Bool>) {
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
                
                VStack {
                    HStack {
                        Text("Simply Task Pro - это")
                            .font(.title)
                            .padding(.top, 20)
                            .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    List {
                        HStack {
                            Text("Большое количество иконок для кастомизации ваших списков")
                                .font(.system(size: 18))
                                .padding(.top, 20)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            
                            Spacer()
                            
                            Image(systemName: "list.bullet.rectangle.portrait")
                                .scaleEffect(1.7)
                        }
                        
                        HStack {
                            Text("Возможность прикреплять неограниченное количество фотографий к задачам")
                                .font(.system(size: 18))
                                .padding(.top, 20)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            
                            Spacer()
                            
                            Image(systemName: "doc")
                                .scaleEffect(1.7)
                        }
                        
                        HStack {
                            Text("Возможность прикреплять любую дату к задачам")
                                .font(.system(size: 18))
                                .padding(.top, 20)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .scaleEffect(1.7)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        storageManager.getPro()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 50)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .padding(.top, 30)
                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : Color(uiColor: .lightGray))
                            
                            Text(storageManager.isPro() ? "Вы пользователь премиума" : "Купить премиум")
                                .foregroundColor(Color(uiColor: .white))
                                .bold()
                                .padding(.top, 29)
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
            }
            .navigationTitle("Simply Task Pro")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView(isScreenPresenting: .constant(true))
    }
}
