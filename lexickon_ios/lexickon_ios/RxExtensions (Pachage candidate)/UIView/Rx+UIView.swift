//
//  Rx+UIView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {
    
    var shake: Binder<Void> {
        return Binder(base) { base, _ in
            base.shake()
        }
    }
}
