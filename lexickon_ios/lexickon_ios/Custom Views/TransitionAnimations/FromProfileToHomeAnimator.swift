//
//  ToHomeAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 01.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout

final class FromProfileToHomeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.4
    
    private let homeVC: HomeViewController
    private let profileVC: ProfileMainScreenViewController
    
    init(
        homeVC: HomeViewController,
        profileVC: ProfileMainScreenViewController
    ) {
        self.homeVC = homeVC
        self.profileVC = profileVC
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
        
        container.frame = profileVC.view.frame
        
        let homeVC = self.homeVC
        let profileVC = self.profileVC
        
        let tmpView = UIView()
        tmpView.frame = profileVC.view.frame
        tmpView.backgroundColor = profileVC.view.backgroundColor
        tmpView.alpha = 0
        
        let tmpProfileIconView = UIView()
        tmpProfileIconView.frame = profileVC.profileIconView.frame
        tmpProfileIconView.backgroundColor = profileVC.profileIconView.backgroundColor
        tmpProfileIconView.layer.cornerRadius = tmpProfileIconView.frame.size.height / 2
        
        container.addSubview(homeVC.view)
        container.addSubview(profileVC.view)
        container.addSubview(tmpView)
        container.addSubview(tmpProfileIconView)
        
        profileVC.profileIconView.isHidden = true
        
        // Profile Icon View animation
        UIView.animate(
            withDuration: Self.duration,
            animations: {
                
                let profileIconViewSize = HomeViewController.UIConstants.profileIconSize
                let profileIconRightMargin = HomeViewController.UIConstants.profileIconRightMargin
                
                tmpProfileIconView.layer.cornerRadius = profileIconViewSize / 2
                
                tmpProfileIconView.pin
                    .size(profileIconViewSize)
                    .right(profileIconRightMargin)
                    .top(tmpView.pin.safeArea.top)
                
            }, completion: { _ in
                homeVC.profileIconView.isHidden = false
                tmpProfileIconView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        
        // BG animation
        // 1
        UIView.animate(
            withDuration: Self.duration/3,
            animations: { tmpView.alpha = 1 },
            completion: { _ in
                profileVC.view.isHidden = true
                // 2
                UIView.animate(
                    withDuration: Self.duration/3,
                    delay: 0,
                    options: .curveLinear,
                    animations: {
                        
                        tmpView.pin
                            .size(homeVC.view.frame.width)
                            .top()
                            .horizontally()

                        tmpView.layer.cornerRadius = homeVC.profileIconView.frame.size.height / 2
                        
                    }, completion: { _ in

                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            delay: 0,
                            options: .curveEaseOut,
                            animations: {
                                
                                tmpView.pin
                                    .top(homeVC.view.pin.safeArea.top)
                                    .right(HomeViewController.UIConstants.profileIconRightMargin)
                                    .size(HomeViewController.UIConstants.profileIconSize)
                                
                            }, completion: { _ in
                                tmpView.removeFromSuperview()
                        })
                })
        })
    }
}
