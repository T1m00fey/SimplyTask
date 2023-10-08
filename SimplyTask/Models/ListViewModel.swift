//
//  ListViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.07.2023.
//

import SwiftUI
import LocalAuthentication

final class ListViewModel: ObservableObject {
    
    @Published var lists: [TaskList] = StorageManager().fetchData()
//    [
//        TaskList(
//            title: "Напоминания",
//            numberOfTasks: 2,
//            colorOfImportant: 1,
//            isPrivate: false,
//            tasks: [
//                StructTask(title: "Сходить в магазин", isDone: false, notificationDate: Date(), isNotificationDone: false, images: [])
//            ],
//            isDoneShowing: true,
//            isMoveDoneToEnd: false,
//            image: "bell"
//        )
//    ]
    
    @Published var isFaceIDSuccess = false
    @Published var isFaceIDError = false
    
    let images = [
        "desktopcomputer",
        "laptopcomputer",
        "folder",
        "paperplane",
        "tray",
        "archivebox",
        "doc",
        "doc.text",
        "doc.plaintext",
        "list.bullet.rectangle.portrait",
        "note.text",
        "book",
        "books.vertical",
        "book.closed",
        "text.book.closed",
        "newspaper",
        "bookmark",
        "graduationcap",
        "person",
        "figure.walk",
        "figure.run",
        "figure.badminton",
        "figure.basketball",
        "figure.cooldown",
        "figure.golf",
        "figure.gymnastics",
        "figure.hiking",
        "figure.hockey",
        "figure.open.water.swim",
        "figure.pool.swim",
        "figure.strengthtraining.traditional",
        "dumbbell",
        "soccerball",
        "baseball",
        "basketball",
        "tennis.racket",
        "sun.max",
        "sunrise",
        "sunset",
        "moon",
        "cloud",
        "cloud.rain",
        "cloud.bolt",
        "snowflake",
        "drop",
        "flame",
        "megaphone",
        "mic",
        "bolt",
        "bolt.horizontal",
        "x.squareroot",
        "camera",
        "text.bubble.fill",
        "phone",
        "envelope",
        "ellipsis",
        "bag",
        "cart",
        "creditcard",
        "hammer",
        "case",
        "house",
        "lightbulb",
        "party.popper",
        "sofa",
        "tent",
        "wifi",
        "pin",
        "airplane",
        "car.side",
        "pill",
        "pills",
        "leaf",
        "camera.macro",
        "tree",
        "brain.head.profile",
        "cube",
        "mug",
        "birthday.cake",
        "list.bullet",
        "text.alignleft",
        "text.justify.left",
        "info",
        "at",
        "checkmark",
        "bell",
        "music.note",
        "magnifyingglass",
        "star",
        "flag",
        "location",
        "tag",
        "building.columns"
    ]
    
    func requestBiometricUnlock(_ closure: @escaping  () -> Void) {
        let context = LAContext()
        
        var error: NSError? = nil
        
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if canEvaluate {
            if context.biometryType != .none {
                print("We got a biometric")
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To access your data") { (success, error) in
                    if success {
                        closure()
                    }
                }
            }
        }
    }
    
    func requestBiometricUnlock(index: Int) {
        let context = LAContext()
        
        var error: NSError? = nil
        
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if lists[index].isPrivate {
            if canEvaluate {
                if context.biometryType != .none {
                    print("We got a biometric")
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To access your data") { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.isFaceIDSuccess = true
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.isFaceIDError = true
                            }
                        }
                    }
                }
            }
        } else {
            isFaceIDSuccess = true
        }
        
        reloadData()
    }
    
    func getColor(by index: Int64) -> Color {
        switch index {
        case 3:
            return .red
        case 2:
            return .yellow
        case 1:
            return .green
        default:
            return .gray
        }
    }
    
    func reloadData() {
        lists = StorageManager().fetchData()
    }
}
