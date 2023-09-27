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
    
    var text = ""
    
    let settings = [
        "Изменить имя",
        "Поделиться приложением",
        "Оценить приложение",
        "Написать разработчику"
    ]
}
