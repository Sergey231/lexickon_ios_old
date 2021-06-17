//
//  MoreButton.swift
//  
//
//  Created by Sergey Borovikov on 17.06.2021.
//

import UIKit
import UIExtensions
import Assets
import SnapKit
import RxCocoa
import RxSwift

public final class MoreButton: UIButton {
    
    private let desposeBag = DisposeBag()
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        self.createUI()
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        backgroundColor = .green
    }
    
    private func configure() {
        
    }
}

private extension Reactive where Base: MoreButton {
    
}
