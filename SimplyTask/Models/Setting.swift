//
//  Setting.swift
//  SimplyTask
//
//  Created by Тимофей Юдин on 14.08.2023.
//

import Foundation

enum Settings {
    case `switch`
}

struct Setting {
    let title: String
    let type: Settings
}
