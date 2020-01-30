//
//  UIBatton+Styles.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setRoundedStyle() {
        superview?.layoutIfNeeded()
        layer.cornerRadius = frame.size.height/2
        setTitleColor(.white, for: .normal)
        backgroundColor = Asset.Colors.mainBG.color
    }
    
    func setRoundedBorderedStyle() {
        setRoundedStyle()
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    func setRoundedFilledStyle() {
        setRoundedStyle()
        setTitleColor(Asset.Colors.mainBG.color, for: .normal)
        backgroundColor = .white
    }
}
