//
//  ErrorFaceIDView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 11.08.2023.
//

import SwiftUI

struct ErrorFaceIDView: View {
    let indexOfList: Int
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            
            Button {
                listViewModel.requestBiometricUnlock(index: indexOfList)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 130, height: 130)
                        .foregroundColor(Color(uiColor: .systemBackground))
                    
                    Image(systemName: "lock")
                        .resizable()
                        .foregroundColor(Color(uiColor: .label))
                        .frame(width: 65, height: 95)
                }
            }
        }

    }
}

struct ErrorFaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorFaceIDView(indexOfList: 0)
            .environmentObject(ListViewModel())
    }
}
