//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 17.10.2020.
//

import UIKit
import RxCocoa
import RxSwift

public extension UIButton {
    
    func configureTapHideAnimation(withAlpha: CGFloat = 0.5) -> CompositeDisposable {
        let tapOnDisposable = rx.controlEvent(.touchDown)
            .subscribe(onNext: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.alpha = withAlpha
                }
            })
        
        let tapOutDisposable = Observable.merge(
            rx.controlEvent(.touchUpInside).asObservable(),
            rx.controlEvent(.touchUpOutside).asObservable()
        )
            .subscribe(onNext: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 1
                }
            })
        
        return CompositeDisposable(
            disposables: [
                tapOnDisposable,
                tapOutDisposable
            ]
        )
    }
    
    func configureTapScaleAnimation(withScale: CGFloat = 0.95) -> CompositeDisposable {
        let tapOnDisposable = rx.controlEvent(.touchDown)
            .subscribe(onNext: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(
                        scaleX: withScale,
                        y: withScale
                    )
                }
            })
        
        let tapOutDisposable = Observable.merge(
            rx.controlEvent(.touchUpInside).asObservable(),
            rx.controlEvent(.touchUpOutside).asObservable()
        )
            .subscribe(onNext: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(
                        scaleX: 1,
                        y: 1
                    )
                }
            })
        
        return CompositeDisposable(
            disposables: [
                tapOnDisposable,
                tapOutDisposable
            ]
        )
    }
}
