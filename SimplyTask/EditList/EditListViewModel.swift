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
    @Published var isDoneShowing = true
    @Published var isMoveDoneToEnd = true
    @Published var isImagesScreenPresenting = false
    
    func getTittleColor(_ index: Int) -> Color {
        if index == selectedLevel {
            return Color(uiColor: .label)
        } else {
            return Color.gray
        }
    }
    
    func getLevelOfImportant(_ color: Int) {
        switch color {
        case 1:
            selectedLevel = 1
        case 2:
            selectedLevel = 2
        case 3:
            selectedLevel = 3
        default:
            selectedLevel = 0
        }
    }
    
    func getLevelOfPrivate(_ isPrivate: Bool) {
        isListPrivate = isPrivate ? true : false
    }
    
    func getNewColorOfImportant() -> Int {
        switch selectedLevel {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 3
        }
    }
    
    func getColorOfImportant(byNum num: Int) -> Color {
        switch num {
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .red
        default:
            return .gray
        }
    }
}
