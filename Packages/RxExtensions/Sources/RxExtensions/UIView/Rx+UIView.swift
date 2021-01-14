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
import SnapKit

public extension Reactive where Base: UIView {
    
    var shake: Binder<Void> {
        return Binder(base) { base, _ in
//            base.shake()
        }
    }
    
    var layoutSubviews: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIView.layoutSubviews))
                .map { _ in () }
        )
    }
    
    var size: ControlEvent<CGSize> {
        ControlEvent(
            events: base.rx.layoutSubviews
                .filter { base.frame.height > 0 && base.frame.width > 0 }
                .map { base.frame.size }
        )
    }
        
    var height: Binder<CGFloat> {
        return Binder(base) { base, height in
            base.snp.remakeConstraints {
                $0.height.equalTo(height)
                $0.width.equalToSuperview()
            }
        }
    }
}
