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
    
    var selectedIndexForDelete = 0
    var textFromAlert = ""
    var textFromEditAlert = ""
    var date = Date.now
    
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
}
