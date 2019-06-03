//
//  UIViewExtensions.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 5/21/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIView {
    
    func appear(duration: TimeInterval = 0.5) -> Single<Void> {
        return changeAlpha(duration: duration, to: 1)
    }
    
    func disappear(duration: TimeInterval = 0.5) -> Single<Void> {
        return changeAlpha(duration: duration, to: 0)
    }
    
    private func changeAlpha(duration: TimeInterval = 0.5, to alpha: CGFloat) -> Single<Void> {
        
        return Single<Void>.create { single -> Disposable in
            
            UIView.animate(
                withDuration: duration,
                animations: { self.alpha = alpha },
                completion: { _ in single(.success(())) }
            )
            
            return Disposables.create()
            
            }
    }
}
