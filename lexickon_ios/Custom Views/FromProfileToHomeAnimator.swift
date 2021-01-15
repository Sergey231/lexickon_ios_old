//
//  ToHomeAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 01.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit

final class FromProfileToHomeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.4
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let homeVC = transitionContext.viewController(forKey: .to) as! HomeViewController
        let profileVC = transitionContext.viewController(forKey: .from) as! ProfileMainScreenViewController
        profileVC.profileIconView.isHidden = true
        
        let tmpView: UIView = {
            let tmpView = UIView()
            tmpView.frame = profileVC.view.frame
            tmpView.backgroundColor = profileVC.view.backgroundColor
            tmpView.alpha = 0
            return tmpView
        }()
        
        let tmpProfileIconView: UIView = {
            let tmpProfileIconView = UIView()
            tmpProfileIconView.frame = profileVC.profileIconView.frame
            tmpProfileIconView.backgroundColor = profileVC.profileIconView.backgroundColor
            tmpProfileIconView.layer.cornerRadius = tmpProfileIconView.frame.size.height / 2
            return tmpProfileIconView
        }()
        
        let container = transitionContext.containerView
        container.frame = profileVC.view.frame
        container.addSubview(homeVC.view)
        container.addSubview(profileVC.view)
        container.addSubview(tmpView)
        container.addSubview(tmpProfileIconView)
        
        // Profile Icon View animation
        UIView.animate(
            withDuration: Self.duration,
            animations: {
                
                let profileIconViewSize = HomeViewController.UIConstants.profileIconSize
                let profileIconRightMargin = HomeViewController.UIConstants.profileIconRightMargin
                
                tmpProfileIconView.layer.cornerRadius = profileIconViewSize / 2
                tmpProfileIconView.snp.makeConstraints {
                    $0.size.equalTo(profileIconViewSize)
                    $0.right.equalToSuperview().offset(-profileIconRightMargin)
                    $0.top.equalTo(homeVC.view.safeAreaInsets.top)
                }
                tmpProfileIconView.superview?.layoutIfNeeded()
                
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
                        
                        tmpView.snp.makeConstraints {
                            $0.size.equalTo(homeVC.view.frame.width)
                            $0.top.equalToSuperview()
                            $0.width.equalToSuperview()
                        }
                        tmpView.superview?.layoutIfNeeded()
                        tmpView.layer.cornerRadius = homeVC.profileIconView.frame.size.height / 2
                        
                    }, completion: { _ in

                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            delay: 0,
                            options: .curveEaseOut,
                            animations: {
                                
                                tmpView.snp.remakeConstraints {
                                    $0.top.equalTo(homeVC.view.safeAreaInsets.top)
                                    $0.right.equalToSuperview().offset(-HomeViewController.UIConstants.profileIconRightMargin)
                                    $0.size.equalTo(HomeViewController.UIConstants.profileIconSize)
                                }
                                tmpView.superview?.layoutIfNeeded()
                                
                            }, completion: { _ in
                                tmpView.removeFromSuperview()
                        })
                })
        })
    }
}
