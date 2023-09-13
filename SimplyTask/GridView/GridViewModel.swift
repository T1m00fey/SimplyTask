//
//  GridViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

final class GridViewModel: ObservableObject {
    @Published var isAlertPresenting = false
    @Published var isDeleteAlertPresenting = false
    @Published var isGridEditing = false
    @Published var isRootLinkActivated = false
    @Published var isSettingsScreenPresenting = false

    var textFromAlert = ""
    var selectedIndexForDelete = 0
    
    let items = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
    
    func getWeekday() -> String {
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
        case 1:
            return "Воскресенье"
        case 2:
            return "Понедельник"
        case 3:
            return "Вторник"
        case 4:
            return  "Среда"
        case 5:
            return "Четверг"
        case 6:
            return "Пятница"
        default:
            return "Cуббота"
        }
    }
}
