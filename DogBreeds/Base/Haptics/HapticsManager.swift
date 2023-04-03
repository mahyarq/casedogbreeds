//
//  HapticsManager.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

struct HapticsManager {
    static let shared = HapticsManager()
    
    func trigger(with style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let hapticIsOn = SettingsManager.shared.isOn(setting: .haptic)
        if !hapticIsOn { return }
        
        let hapticGenerator = UIImpactFeedbackGenerator(style: style)
        hapticGenerator.impactOccurred()
    }
}
