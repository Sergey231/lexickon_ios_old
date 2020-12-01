//
//  ToNewWordAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout
import UIExtensions

final class ToNewWordAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 4
    
    private let homeVC: HomeViewController
    private let addSearchWordVC: AddSearchWordViewController
    
    init(
        homeVC: HomeViewController,
        addSearchWordVC: AddSearchWordViewController
    ) {
        self.homeVC = homeVC
        self.addSearchWordVC = addSearchWordVC
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        let homeVC = self.homeVC
        let addSearchWordVC = self.addSearchWordVC
        
        container.frame = homeVC.view.frame
        let tmpView = UIView()
        guard let circleViewFrame = homeVC.addWordButton.circleView.globalFrame else {
            return
        }
        tmpView.frame = circleViewFrame
        tmpView.backgroundColor = homeVC.addWordButton.circleView.backgroundColor
        tmpView.layer.cornerRadius = tmpView.frame.size.height / 2
        
        addSearchWordVC.view.isHidden = true
        let tmpAddSearchWordHeaderView = UIView()
        tmpAddSearchWordHeaderView.frame = circleViewFrame
        
        container.addSubview(addSearchWordVC.view)
        container.addSubview(tmpView)
        container.addSubview(tmpAddSearchWordHeaderView)
        
        // 1
        UIView.animate(
            withDuration: Self.duration/3,
            delay: 0,
            options: .curveEaseIn,
            animations: {

                tmpView.pin
                    .horizontally()
                    .bottom()
                    .height(addSearchWordVC.view.frame.width)

            }, completion: { _ in
                // 2
                UIView.animate(
                    withDuration: Self.duration/3,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: { tmpView.pin.all() },
                    completion: { _ in

                        addSearchWordVC.view.isHidden = false
                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            animations: { tmpView.alpha = 0 },
                            completion: { _ in
                                tmpView.removeFromSuperview()
                        })
                })
        })
    }
}
