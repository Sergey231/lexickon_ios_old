//
//  Rx+UITextField.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 08.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public extension Reactive where Base: UITextField {
    
    var returnDidTap: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.controlEvent(.editingDidEndOnExit)
        )
    }
    
    var isFocused: Driver<Bool> {
        
        let editingDidBegin = base.rx
            .controlEvent(UIControl.Event.editingDidBegin)
            .map { _ in true }
            .asDriver(onErrorDriveWith: .empty())
        
        let editingDidEnd = base.rx
            .controlEvent(UIControl.Event.editingDidEnd)
            .map { _ in false }
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver<Bool>.merge(
            editingDidBegin,
            editingDidEnd
        )
    }
}
