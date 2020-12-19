//
//  Animator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 27.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit

final class FromHomeToProfileAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.8
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let homeVC = transitionContext.viewController(forKey: .from) as! HomeViewController
        let profileVC = transitionContext.viewController(forKey: .to) as! ProfileMainScreenViewController
        profileVC.view.isHidden = true
        profileVC.profileIconView.isHidden = true
        
        
        let tmpView: UIView = {
            let tmpView = UIView()
            tmpView.frame = homeVC.profileIconView.frame
            tmpView.backgroundColor = profileVC.view.backgroundColor
            tmpView.layer.cornerRadius = tmpView.frame.size.height / 2
            return tmpView
        }()
        
        let tmpProfileIconView: UIView = {
            let tmpProfileIconView = UIView()
            tmpProfileIconView.frame = homeVC.profileIconView.frame
            tmpProfileIconView.backgroundColor = .gray
            tmpProfileIconView.layer.cornerRadius = homeVC.profileIconView.layer.cornerRadius
            return tmpProfileIconView
        }()
        
        let container = transitionContext.containerView
        container.frame = homeVC.view.frame
        container.addSubview(profileVC.view)
        container.addSubview(tmpView)
        container.addSubview(tmpProfileIconView)
        
        //MARK: Profile Icon Animation
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
                tmpProfileIconView.snp.makeConstraints{
                    $0.size.equalTo(profileIconViewSize)
                    $0.top.equalTo(profileIconTopMargin)
                    $0.centerX.equalToSuperview()
                }
                tmpProfileIconView.superview?.layoutIfNeeded()

            }, completion: { _ in
                profileVC.profileIconView.isHidden = false
                tmpProfileIconView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        
        //MARK: Main View Animation
        UIView.animate(
            withDuration: Self.duration/3,
            delay: 0,
            options: .curveEaseIn,
            animations: {

                tmpView.snp.makeConstraints {
                    $0.width.equalToSuperview()
                    $0.top.equalToSuperview()
                    $0.height.equalTo(profileVC.view.frame.width)
                }
                tmpView.superview?.layoutIfNeeded()

            }, completion: { _ in
                // 2
                UIView.animate(
                    withDuration: Self.duration/3,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        tmpView.snp.remakeConstraints {
                            $0.edges.equalToSuperview()
                        }
                        tmpView.superview?.layoutIfNeeded()
                    },
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
