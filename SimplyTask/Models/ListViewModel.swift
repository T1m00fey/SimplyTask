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
    
    @Published var isFaceIDSuccess = false
    @Published var isFaceIDError = false
    
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
