//
//  StartLogo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 5/19/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

final class StartLogoView: UIView {
    
    let logoImageView = UIImageView()
    let textLogoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [logoImageView,
         textLogoImageView].forEach {
            addSubview($0)
        }
        
        logoImageView.image = Asset.Images.logo.image
        logoImageView.contentMode = .scaleAspectFit
        textLogoImageView.image = Asset.Images.textLogo.image
        textLogoImageView.contentMode = .scaleAspectFit
        textLogoImageView.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func shiftUp(duration: TimeInterval = 0.6) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            
            UIView.animate(
                withDuration: duration,
                animations: {
                    self.logoImageView.pin
                        .size(94)
                        .hCenter()
                        .bottom(80)
            }, completion: { _ in observer.onNext(()) })
            
            return Disposables.create()
            
            }.take(1)
            .observeOn(MainScheduler.instance)
    }
    
    func animate() -> Driver<Void> {
        return Observable.concat([
            shiftUp(),
            textLogoImageView.appear(duration: 0.6).asObservable()
            ]).asDriver(onErrorJustReturn: ())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.pin
            .size(94)
            .hCenter()
            .bottom()
        
        textLogoImageView.pin
            .width(183)
            .height(49)
            .center()
    }
}
