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
}
