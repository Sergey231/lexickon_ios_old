//
//  Button.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

final class Button: UIButton {
    
    //MARK: init from View Controller
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    //MAEK: init from XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    func configureButton() {
        
    }
}
