//
//  Rx+UIImageView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 18.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIImageView {
    
    var imageWithAnimation: Binder<UIImage> {
        return Binder(base) { base, image in
            
            if base.image == nil {
                base.alpha = 0
                base.image = image
                UIView.animate(withDuration: 0.1) {
                    base.alpha = 1
                }
            } else {
                
                UIView.animate(withDuration: 0.1) {
                    base.alpha = 0
                } completion: { _ in
                    base.image = image
                    UIView.animate(withDuration: 0.1) {
                        base.alpha = 1
                    }
                }
            }
        }
    }
}

