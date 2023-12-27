//
//  ListViewModel.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 17.07.2023.
//

import SwiftUI
import LocalAuthentication

final class ListViewModel: ObservableObject {
    
    @Published var lists: [TaskList] = []
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
    
    func requestBiometricUnlock(_ closure: @escaping () -> Void) {
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
    
    func getImages(fromList listIndex: Int, fromTask taskIndex: Int) -> [UIImage] {
        var images: [UIImage] = []
        let imagesData = lists[listIndex].tasks[taskIndex].images
        
        for image in imagesData {
            images.append(UIImage(data: image) ?? UIImage(systemName: "bell")!)
        }
        
        return images
    }
    
    func moveTaskToBegin(listIndex: Int, taskIndex: Int) {
        for indexOfTask in 0..<taskIndex {
            if lists[listIndex].tasks[indexOfTask].isDone {
                lists[listIndex].tasks.move(fromOffsets: IndexSet(integer: taskIndex), toOffset: indexOfTask)
                break;
            }
        }
    }
    
    func moveTaskToEnd(listIndex: Int, taskIndex: Int) {
        lists[listIndex].tasks.move(fromOffsets: IndexSet(integer: taskIndex), toOffset: lists[listIndex].tasks.count)
    }
    
    func addImage(toList listIndex: Int, andTask taskIndex: Int, photos: [UIImage]) {
        var data: [Data] = []
        
        for photo in photos {
            data.append(photo.jpegData(compressionQuality: 1) ?? Data())
        }
        
        withAnimation {
            lists[listIndex].tasks[taskIndex].images = data
        }
    }
    
    func getImage(fromList listIndex: Int, fromTask taskIndex: Int) -> [UIImage] {
        var images: [UIImage] = []
        let imagesData = lists[listIndex].tasks[taskIndex].images
        
        for image in imagesData {
            images.append(UIImage(data: image) ?? UIImage(systemName: "bell")!)
        }
        
        return images
    }
    
    func newTask(toList index: Int, newTask task: StructTask) {
        lists[index].tasks.append(task)
        
        for indexOfTask in 0..<lists[index].tasks.count {
            if lists[index].tasks[indexOfTask].isDone {
                lists[index].tasks.move(fromOffsets: IndexSet(integer: lists[index].tasks.count - 1), toOffset: indexOfTask)
                break;
            }
        }
    }
}
