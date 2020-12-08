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
    
    static let duration: TimeInterval = 0.6
    
    private let addSearchWordVC: AddSearchWordViewController
    
    init(
        addSearchWordVC: AddSearchWordViewController
    ) {
        self.addSearchWordVC = addSearchWordVC
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let container = transitionContext.containerView
        
        let homeVC = transitionContext.viewController(forKey: .from) as! HomeViewController
        let addSearchWordVC = self.addSearchWordVC
        
        container.frame = addSearchWordVC.view.frame
        let tmpView = UIView()
        guard let circleViewFrame = homeVC.addWordButton.circleView.globalFrame else {
            return
        }
        tmpView.frame = circleViewFrame
        tmpView.backgroundColor = .white
        tmpView.layer.cornerRadius = circleViewFrame.size.height / 2
        tmpView.clipsToBounds = true
        
        addSearchWordVC.view.isHidden = true
        
        let tmpAddSearchWordHeaderView = UIView()
        tmpAddSearchWordHeaderView.backgroundColor = homeVC.addWordButton.circleView.backgroundColor
        tmpAddSearchWordHeaderView.frame = CGRect(
            x: 0,
            y: 0,
            width: circleViewFrame.width,
            height: circleViewFrame.height
        )
        tmpAddSearchWordHeaderView.layer.cornerRadius = circleViewFrame.size.height / 2
        
        container.addSubview(addSearchWordVC.view)
        tmpView.addSubview(tmpAddSearchWordHeaderView)
        container.addSubview(tmpView)
        
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

                tmpAddSearchWordHeaderView.pin
                    .horizontally()
                    .top()
                    .height(AddSearchWordViewController.UIConstants.headerViewHeight)

                tmpAddSearchWordHeaderView.layer.cornerRadius = 0
                homeVC.view.alpha = 0.7

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
                                homeVC.view.alpha = 1
                                tmpAddSearchWordHeaderView.removeFromSuperview()
                                tmpView.removeFromSuperview()
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        })
                })
        })
    }
}
