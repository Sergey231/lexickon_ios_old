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

extension Reactive where Base: UITextField {
    
    public var returnDidTap: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.controlEvent(.editingDidEndOnExit)
        )
    }
}
