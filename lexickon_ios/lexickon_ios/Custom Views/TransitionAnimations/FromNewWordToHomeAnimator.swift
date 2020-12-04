//
//  FromNewWordToHomeAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout

final class FromNewWordToHomeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.4
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        let container = transitionContext.containerView
        
        let homeVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! HomeViewController
        let addSearchWordVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AddSearchWordViewController
        
        homeVC.view.alpha = 0.6
        
        let tmpView = UIView()
        tmpView.frame = addSearchWordVC.view.frame
        tmpView.backgroundColor = addSearchWordVC.view.backgroundColor
        tmpView.alpha = 0
        
        let tmpHeaderView = UIView()
        tmpHeaderView.frame = addSearchWordVC.headerView.frame
        tmpHeaderView.backgroundColor = addSearchWordVC.headerView.backgroundColor
        
        container.addSubview(homeVC.view)
        container.addSubview(addSearchWordVC.view)
        tmpView.addSubview(tmpHeaderView)
        container.addSubview(tmpView)
        
        // 1
        UIView.animate(
            withDuration: Self.duration/3,
            animations: { tmpView.alpha = 1 },
            completion: { _ in
                addSearchWordVC.view.isHidden = true
                // 2
                UIView.animate(
                    withDuration: Self.duration/3,
                    delay: 0,
                    options: .curveLinear,
                    animations: {
                        
                        tmpView.pin
                            .size(homeVC.view.frame.width)
                            .bottom()
                            .horizontally()

                        tmpView.layer.cornerRadius = homeVC.addWordButton.circleView.frame.size.height / 2
                        tmpHeaderView.layer.cornerRadius = homeVC.addWordButton.circleView.frame.size.height / 2
                        homeVC.view.alpha = 0.8
                        
                    }, completion: { _ in

                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            delay: 0,
                            options: .curveEaseOut,
                            animations: {
                                
                                tmpView.frame = homeVC.addWordButton.circleView.globalFrame!
                                tmpHeaderView.frame = CGRect(
                                    x: 0,
                                    y: 0,
                                    width: tmpView.frame.size.width,
                                    height: tmpView.frame.size.height
                                )
                                homeVC.view.alpha = 1
                                
                            }, completion: { _ in
                                tmpHeaderView.removeFromSuperview()
                                tmpView.removeFromSuperview()
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        })
                })
        })
    }
}
