//
//  SettingsView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 14.08.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themesViewModel: ThemesViewModel
    
    @Binding var isScreenPresenting: Bool
    
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
                    Text("Тема: ")
                        .font(.system(size: 20))
                        .frame(width: 350, alignment: .bottomLeading)
                        .padding(.top, 30)
                        
                    HStack(spacing: 90) {
                        ForEach(themesViewModel.themes.indices, id: \.self) { index in
                            ZStack {
                                if themesViewModel.themes[index].isSelected {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 105, height: 45)
                                        .foregroundColor(Color(uiColor: .systemGray6))
                                        .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color(uiColor: .label), lineWidth: 3))
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 45)
                                        .foregroundColor(Color(uiColor: .systemGray6))
                                }
                                
                                Text(themesViewModel.themes[index].title)
                                    .font(.system(size: 18))
                            }
                            .onTapGesture {
                                withAnimation {
                                    themesViewModel.themes.indices.forEach { index in
                                        themesViewModel.themes[index].isSelected.toggle()
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isScreenPresenting.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(uiColor: .label))
                    }

                }
            }
            .environment(\.colorScheme, themesViewModel.getColorScheme(colorScheme))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isScreenPresenting: .constant(true))
            .environmentObject(ThemesViewModel())
    }
}
