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
}
