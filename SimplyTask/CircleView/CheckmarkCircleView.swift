//
//  CheckmarkCircleView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 07.12.2023.
//

import SwiftUI

struct CheckmarkCircleView: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 23, height: 23)
            .foregroundColor(.green)
            //.overlay(Circle().stroke(Color(uiColor: .label), lineWidth: 1))
    }
}

#Preview {
    CheckmarkCircleView()
}
