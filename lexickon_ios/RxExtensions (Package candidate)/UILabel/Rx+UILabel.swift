//
//  Rx+UILabel.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UILabel {
    
    var textWithAnimaiton: Binder<String> {
        return Binder(base) { label, newText in
            
            if let labelText = base.text,
               !labelText.isEmpty {
                UIView.animate(withDuration: 0.2) {
                    base.alpha = 0
                } completion: { _ in
                    base.text = newText
                    UIView.animate(withDuration: 0.4) {
                        base.alpha = 1
                    }
                }
                return
            }
            base.alpha = 0
            base.text = newText
            UIView.animate(withDuration: 0.4) {
                base.alpha = 1
            }
        }
    }
}
