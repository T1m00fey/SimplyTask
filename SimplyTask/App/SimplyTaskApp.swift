//
//  SimplyTaskApp.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 13.07.2023.
//

import SwiftUI

@main
struct SimplyTaskApp: App {
    var body: some Scene {
        WindowGroup {
            GridView()
                .environmentObject(GridViewModel())
                .environmentObject(ListViewModel())
        }
    }
}
