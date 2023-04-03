//
//  SettingsManager.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import Foundation

struct SettingsManager {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard
    
    func save(setting: Setting, isOn: Bool) {
        defaults.set(isOn ,forKey: setting.rawValue)
    }
    
    func isOn(setting: Setting) -> Bool {
        defaults.bool(forKey: setting.rawValue)
    }
}
