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
    private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    @State private var mailData = ComposeMailData(
        subject: "Разработчику",
         recipients: ["simply.develop@mail.ru"],
         message: """
                    Приложение: Simply Task
                    iOS: \(UIDevice.current.systemVersion)
                    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
                
                    Ваш вопрос...
                """,
         attachments: []
    )
    @StateObject var viewModel = SettingsViewModel()
    
    @Binding var isScreenPresenting: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    init(isScreenPresenting: Binding<Bool>) {
        self._isScreenPresenting = isScreenPresenting
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        softFeedback.prepare()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                VStack {
//                    Button {
////                        if !storageManager.isPro() {
//                            viewModel.isPremiumViewPresenting.toggle()
////                        }
//                    } label: {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(height: 50)
//                                .padding(.leading, 20)
//                                .padding(.trailing, 20)
//                                .padding(.top, 30)
//                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : Color(uiColor: .lightGray))
//                            
//                            Text(storageManager.isPro() ? "Вы пользователь премиума" : "Купить премиум")
//                                .foregroundColor(Color(uiColor: .white))
//                                .bold()
//                                .padding(.top, 29)
//                        }
//                    }
//                    .sheet(isPresented: $viewModel.isPremiumViewPresenting) {
//                        PremiumView(isScreenPresenting: $viewModel.isPremiumViewPresenting)
//                    }
                    
                    List {
                        Button {
                            viewModel.isEditAlertPresenting.toggle()
                            viewModel.text = storageManager.fetchName()
                        } label: {
                            HStack {
                                Text(viewModel.settings[0])
                                
                                Spacer()
                                
                                Image(systemName: "person")
                            }
                        }
                        .alert("Изменить имя", isPresented: $viewModel.isEditAlertPresenting) {
                            TextField("", text: $viewModel.text)
                            
                            Button("Отмена", role: .cancel) {}
                            
                            Button("Изменить", role: .none) {
                                viewModel.isEditAlertPresenting.toggle()
                                storageManager.save(name: viewModel.text)
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            VStack {
                                HStack {
                                    Text(viewModel.settings[1])
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Имя")
                                    
//                                    Spacer()
                                    
                                    Button {
                                        storageManager.setModeForMainScreen("name")
                                        
                                        withAnimation {
                                            viewModel.modeForMainScreen = "name"
                                        }
                                        
                                        softFeedback.impactOccurred()
                                    } label: {
                                        if viewModel.modeForMainScreen == "name" {
                                            CheckmarkCircleView()
                                        } else {
                                            EmptyCircleView()
                                        }
                                    }
                                }
                                
                                HStack {
                                    Text("Дата")
                                    
//                                    Spacer()
                                    
                                    Button {
                                        storageManager.setModeForMainScreen("date")
                                        
                                        withAnimation {
                                            viewModel.modeForMainScreen = "date"
                                        }
                                        
                                        softFeedback.impactOccurred()
                                    } label: {
                                        if viewModel.modeForMainScreen == "date" {
                                            CheckmarkCircleView()
                                        } else {
                                            EmptyCircleView()
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        Button {
                            viewModel.isShareSheetPresenting.toggle()
                        } label: {
                            HStack {
                                Text(viewModel.settings[2])
                                
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
                                Text(viewModel.settings[3])
                                
                                Spacer()
                                
                                Image(systemName: "star")
                            }
                        }
                        
                        
                        Button {
                            viewModel.isEmailViewPresenting.toggle()
                        } label: {
                            HStack {
                                Text(viewModel.settings[4])
                                
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
                    }.padding(.bottom, 30)
                }
            }
            .navigationTitle("Информация")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.modeForMainScreen = storageManager.fetchModeForMainScreen()
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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isScreenPresenting: .constant(true))
    }
}
