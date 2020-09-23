//
//  UIView+Animations.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

extension UIView {
    
    public func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        
        shake.fromValue = NSValue(cgPoint: toPoint)
        shake.toValue = NSValue(cgPoint: fromPoint)
        
        layer.add(shake, forKey: "position")
    }
    
    public func fadeInAnimate(timeInterval: TimeInterval = 1) {
        UIView.animate(withDuration: timeInterval) {
            self.alpha = 1
        }
    }
    
    public func fadeOutAnimate(timeInterval: TimeInterval = 1) {
        UIView.animate(withDuration: timeInterval) {
            self.alpha = 0
        }
    }
    
    public func round() {
        superview?.layoutIfNeeded()
        let h = frame.size.height
        let w = frame.size.width
        let shortSide = w >= h ? h : w
        layer.cornerRadius = shortSide/2
    }
    
    public func performVCollapseAnimation(
        timeInterval: TimeInterval = 0.1,
        completion: (() -> Void)? = nil,
        repeatCount: Float = 1
    ) {
        CATransaction.begin()
        let anim = CABasicAnimation(keyPath: "transform")
        anim.toValue = CATransform3DMakeRotation(-1.6, 1, 0, 0)
        anim.duration = timeInterval
        anim.autoreverses = true
        anim.repeatCount = repeatCount
        CATransaction.setCompletionBlock(completion)
        layer.add(anim, forKey: "transform")
        CATransaction.commit()
    }
    
    public func startFlayingAnimation() {
        UIView.flayingAnimate = true
        flayingAnimate()
    }
    
    public func stopFlayingAnimation() {
        UIView.flayingAnimate = false
    }
    
    private static var flayingAnimate: Bool = false
    private func flayingAnimate() {
        let startY = layer.frame.origin.y
        UIView.animate(withDuration: 3, animations: {
            self.layer.frame.origin.y = startY + 10
        }) { _ in
            let startY = self.layer.frame.origin.y
            UIView.animate(withDuration: 3, animations: {
                self.layer.frame.origin.y = startY - 10
            }) { _ in
                if UIView.flayingAnimate {
                    self.flayingAnimate()
                }
            }
        }
    }
}
