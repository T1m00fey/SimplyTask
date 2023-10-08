//
//  TasksListViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.07.2023.
//

import SwiftUI
import LocalAuthentication

final class TasksListViewModel: ObservableObject {
    @Published var isListEditing = false
    @Published var isAlertForNewTaskPresenting = false
    @Published var isAlertForDeletePresenting = false
    @Published var isErrorAlertPresenting = false
    @Published var isEditScreenPresenting = false
    @Published var isAlertForEditingPresenting = false
    @Published var isNotificationMenuShowing = false
    @Published var isList = false
    @Published var isPhotoScreenPresenting = false
    @Published var isDetailPhotoScreenPresenting = false
    @Published var isAlertForDeletePresenting2 = false
    @Published var isShareSheetPresenting = false
    
    var selectedIndexForDelete = 0
    var textFromAlert = ""
    var textFromEditAlert = ""
    var date = Date.now
    var titleOfTask = ""
    var image = UIImage(systemName: "bell")
    
    func getDoneOfTask(_ isDone: Bool) -> Int {
        if isDone {
            return 1
        } else {
            return 2
        }
    }
    
    func getTitleOfTask(_ isDone: Bool) ->  Color {
        if isDone {
            return .gray
        } else {
            return Color(uiColor: .label)
        }
    }
    
    func getStringDate(fromDate date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        var stringMonth = ""
        
        switch month {
        case 1:
            stringMonth = "Января"
        case 2:
            stringMonth = "Февраля"
        case 3:
            stringMonth = "Марта"
        case 4:
            stringMonth = "Аперля"
        case 5:
            stringMonth = "Мая"
        case 6:
            stringMonth = "Июня"
        case 7:
            stringMonth = "Июля"
        case 8:
            stringMonth = "Августа"
        case 9:
            stringMonth = "Сентября"
        case 10:
            stringMonth = "Октября"
        case 11:
            stringMonth = "Ноября"
        default:
            stringMonth = "Декабря"
        }
        
        return "\(day) \(stringMonth) \(year)"
    }
}
