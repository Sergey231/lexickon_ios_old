//
//  UIBatton+Styles.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

extension UIButton {
    
    public func setRoundedStyle(bgColor: UIColor = .gray) {
        superview?.layoutIfNeeded()
        layer.cornerRadius = frame.size.height/2
        setTitleColor(.white, for: .normal)
        backgroundColor = bgColor
    }
    
    public func setRoundedBorderedStyle(bgColor: UIColor = .gray) {
        setRoundedStyle(bgColor: bgColor)
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    public func setRoundedFilledStyle(
        fillColor: UIColor = .white,
        titleColor: UIColor = .gray
    ) {
        setRoundedStyle(bgColor: fillColor)
        setTitleColor(titleColor, for: .normal)
    }
}