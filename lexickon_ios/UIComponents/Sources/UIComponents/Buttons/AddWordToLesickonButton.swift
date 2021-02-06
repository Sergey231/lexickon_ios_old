//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 16.01.2021.
//

import UIKit
import UIExtensions

public final class AddWordToLesickonButton: UIButton {
    
    public var myValue: Int
    
    required init(value: Int = 0) {
        
        self.myValue = value
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        layer.cornerRadius = CornerRadius.regular
        backgroundColor = .lightGray
    }
}
