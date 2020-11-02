//
//  Animator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 27.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout

final class ToProfileAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.8
    
    private let homeVC: HomeViewController
    private let profileVC: ProfileMainScreenViewController
    
    init?(
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
        
        guard
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else {
            return
        }
        
        let homeVC = self.homeVC
        let profileVC = self.profileVC
        
        container.frame = homeVC.view.frame
        let tmpView = UIView()
        tmpView.frame = homeVC.profileIconView.frame
        tmpView.backgroundColor = toView.backgroundColor
        tmpView.layer.cornerRadius = tmpView.frame.size.height / 2
        
        toView.isHidden = true
        let tmpProfileIconView = UIView()
        tmpProfileIconView.frame = homeVC.profileIconView.frame
        tmpProfileIconView.backgroundColor = .gray
        tmpProfileIconView.layer.cornerRadius = homeVC.profileIconView.layer.cornerRadius
        
        container.addSubview(toView)
        container.addSubview(tmpView)
        container.addSubview(tmpProfileIconView)
        
        profileVC.profileIconView.isHidden = true
        
        UIView.animate(
            withDuration: Self.duration,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {

                let profileIconViewSize = ProfileMainScreenViewController.UIConstants.profileIconSize
                let profileIconTopMargin = ProfileMainScreenViewController.UIConstants.profileIconTopMargin
                    + profileVC.view.pin.safeArea.top

                tmpProfileIconView.layer.cornerRadius = profileIconViewSize / 2

                tmpProfileIconView.pin
                    .size(profileIconViewSize)
                    .hCenter()
                    .top(profileIconTopMargin)

            }, completion: { _ in
                profileVC.profileIconView.isHidden = false
                tmpProfileIconView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        
        // 1
        UIView.animate(
            withDuration: Self.duration/3,
            delay: 0,
            options: .curveEaseIn,
            animations: {

                tmpView.pin
                    .horizontally()
                    .top()
                    .height(profileVC.view.frame.width)

            }, completion: { _ in
                // 2
                UIView.animate(
                    withDuration: Self.duration/3,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: { tmpView.pin.all() },
                    completion: { _ in

                        profileVC.view.isHidden = false
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
