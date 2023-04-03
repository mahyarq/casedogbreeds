//
//  SettingsViewModel.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import Foundation

enum Setting: String {
    case darkMode = "Dark mode"
    case haptic = "Haptic feedback"
}

final class SettingsViewModel {
    let settings: [Setting] = [
        .darkMode,
        .haptic
    ]
    
    func set(setting: Setting, isOn: Bool) {
        SettingsManager.shared.save(setting: setting, isOn: isOn)
    }
    
    func isOn(setting: Setting) -> Bool {
        SettingsManager.shared.isOn(setting: setting)
    }
}
