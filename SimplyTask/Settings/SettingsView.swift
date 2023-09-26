//
//  SettingsView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 22.09.2023.
//

import SwiftUI
import MessageUI
import SwiftUIMailView

struct SettingsView: View {
    private let storageManager = StorageManager.shared
    
    @State private var mailData = ComposeMailData(
        subject: "Поддержка",
         recipients: ["simplyapp@mail.ru"],
         message: """
                    Устройство: \(UIDevice.current.name)
                    iOS: \(UIDevice.current.systemVersion)
                    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
                
                    Ваш вопрос...
                """,
         attachments: []
    )
    @StateObject var viewModel = SettingsViewModel()
    
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
                
                List {
                    Button {
                        viewModel.isShareSheetPresenting.toggle()
                    } label: {
                        HStack {
                            Text(viewModel.settings[0])
                            
                            Spacer()
                            
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    .sheet(isPresented: $viewModel.isShareSheetPresenting) {
                        ShareSheet(activityItems: ["app URL"])
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text(viewModel.settings[1])
                            
                            Spacer()
                            
                            Image(systemName: "star")
                        }
                    }
                    
                    
                    Button {
                        viewModel.isEmailViewPresenting.toggle()
                    } label: {
                        HStack {
                            Text(viewModel.settings[2])
                            
                            Spacer()
                            
                            Image(systemName: "envelope")
                        }
                    }
                    .disabled(!MailView.canSendMail)
                    .sheet(isPresented: $viewModel.isEmailViewPresenting) {
                        MailView(data: $mailData) { result in
                            print(result)
                        }
                    }
                }
            }
            .navigationTitle("Информация")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isScreenPresenting: .constant(true))
    }
}
