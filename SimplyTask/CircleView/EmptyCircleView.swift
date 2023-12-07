//
//  EmptyCircleView.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 07.12.2023.
//

import SwiftUI

struct EmptyCircleView: View {
    var body: some View {
        Circle()
            .frame(width: 23, height: 23)
            .overlay(Circle().stroke(Color(uiColor: .label), lineWidth: 1))
            .foregroundColor(Color(uiColor: .systemBackground))
    }
}

#Preview {
    EmptyCircleView()
}
