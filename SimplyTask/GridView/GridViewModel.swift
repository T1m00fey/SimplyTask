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
    @Published var greeting = ""
    @Published var isList = false
    @Published var modeForMainScreen = ""

    var textFromAlert = ""
    var selectedIndexForDelete = 0
    var isPrivateListPermitForDelete = false
    
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
    
    func getGreeting() -> String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        let time = dateFormatter.string(from: date)
        
        var result = ""
        
        if (22...23).contains(Int(time) ?? 12) || (0...5).contains(Int(time) ?? 12) {
            result = "Доброй ночи"
        } else if (6...11).contains(Int(time) ?? 12) {
            result = "Доброе утро"
        } else if (12...17).contains(Int(time) ?? 12) {
            result = "Добрый день"
        } else if (18...21).contains(Int(time) ?? 12) {
            result = "Добрый вечер"
        }
        
        return result
    }
    
    func getGreetingImage() -> String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        let time = dateFormatter.string(from: date)
        
        var result = ""
        
        if (22...23).contains(Int(time) ?? 12) || (0...5).contains(Int(time) ?? 12) {
            result = "moon"
        } else if (6...11).contains(Int(time) ?? 12) {
            result = "sunrise"
        } else if (12...17).contains(Int(time) ?? 12) {
            result = "sun.max"
        } else if (18...21).contains(Int(time) ?? 12) {
            result = "sunset"
        }
        
        return result
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
    
    func getDate() -> String {
        let date = Date.now
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        var stringMonth = ""
        
        switch month {
        case 1:
           stringMonth = "января"
        case 2:
           stringMonth = "февраля"
        case 3:
           stringMonth = "марта"
        case 4:
           stringMonth = "апреля"
        case 5:
           stringMonth = "мая"
        case 6:
           stringMonth = "июня"
        case 7:
           stringMonth = "июля"
        case 8:
           stringMonth = "августа"
        case 9:
           stringMonth = "сентября"
        case 10:
           stringMonth = "октября"
        case 11:
           stringMonth = "ноября"
        default:
           stringMonth = "декабря"
        }
        
        return "\(day) \(stringMonth)"
    }
}
