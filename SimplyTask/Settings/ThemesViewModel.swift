//
//  SettingsViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 14.08.2023.
//

import SwiftUI

final class ThemesViewModel: ObservableObject {
    @Published var themes = [
        Theme(title: "Системная", isSelected: true),
        Theme(title: "Тёмная", isSelected: false)
    ]
    
    func getColorScheme(_ colorScheme: ColorScheme) -> ColorScheme {
        if themes[1].isSelected {
            return .dark
        } else if colorScheme == .light {
            return .light
        } else {
            return .dark
        }
    }
}
