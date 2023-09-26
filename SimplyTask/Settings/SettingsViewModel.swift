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
    
    let settings = [
        "Поделиться приложением",
        "Оценить приложение",
        "Написать разработчику"
    ]
}
