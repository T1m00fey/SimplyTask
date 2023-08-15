//
//  NewTaskViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

final class EditListViewModel: ObservableObject {
    let colors: [Color] = [.gray, .green, .yellow, .red]
    let levels = ["Нулевой", "Низкий", "Средний", "Высокий"]
    
    var textFromTF = ""
    var selectedLevel = 0
    @Published var isListPrivate = false
    @Published var selectedColor = Color.gray
    @Published var isDeleteAlertPresenting = false
    @Published var isBiometricSuccess = false
    
    func getTittleColor(_ index: Int) -> Color {
        if index == selectedLevel {
            return Color(uiColor: .label)
        } else {
            return Color.gray
        }
    }
    
    func getLevelOfImportant(_ color: Color) {
        switch color {
        case .green:
            selectedLevel = 1
        case .yellow:
            selectedLevel = 2
        case .red:
            selectedLevel = 3
        default:
            selectedLevel = 0
        }
    }
    
    func getLevelOfPrivate(_ isPrivate: Bool) {
        isListPrivate = isPrivate ? true : false
    }
    
    func getColorOfImportant() -> Color {
        switch selectedLevel {
        case 0:
            return .gray
        case 1:
            return .green
        case 2:
            return .yellow
        default:
            return .red
        }
    }
}
