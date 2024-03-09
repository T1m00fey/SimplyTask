//
//  SettingsViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 22.09.2023.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var isEmailViewPresenting = false
    @Published var isShareSheetPresenting = false
    @Published var isEditAlertPresenting = false
    @Published var isPremiumViewPresenting = false
    @Published var modeForMainScreen = ""
    
    var text = ""
    
    let settings = [
        "Изменить имя",
        "Отображать на главном экране: ",
        "Поделиться приложением",
        "Оценить приложение",
        "Написать разработчику"
    ]
}
