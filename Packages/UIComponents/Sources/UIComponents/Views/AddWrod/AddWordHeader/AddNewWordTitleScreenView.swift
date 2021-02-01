//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 01.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Assets
import UIExtensions
import RxExtensions

public final class AddNewWordTitleScreenView: UIView {
    
    public init() {
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        backgroundColor = .gray
    }
}
