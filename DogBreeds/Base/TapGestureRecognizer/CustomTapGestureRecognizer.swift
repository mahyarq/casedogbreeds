//
//  CustomTapGestureRecognizer.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        HapticsManager.shared.trigger(with: .light)
        
        animate(isHighlighted: true) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.animate(isHighlighted: false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.2,
                           options: animationOptions, animations: {
                self.view?.transform = .init(scaleX: 0.97, y: 0.97)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.2,
                           options: animationOptions, animations: {
                self.view?.transform = .identity
            }, completion: completion)
        }
    }
}
