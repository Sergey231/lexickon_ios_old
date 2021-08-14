//
//  ToHomeAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 01.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit

public final class FromProfileToHomeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let profileVCProfileIconView: UIView
    private let homeVCProfileIconView: UIView
    private let homeVCProfileIconSize: CGFloat
    private let homeVCProfileIconRightMargin: CGFloat
    
    public init(
        profileVCProfileIconView: UIView,
        homeVCProfileIconView: UIView,
        homeVCProfileIconSize: CGFloat,
        homeVCProfileIconRightMargin: CGFloat
    ) {
        self.profileVCProfileIconView = profileVCProfileIconView
        self.homeVCProfileIconView = homeVCProfileIconView
        self.homeVCProfileIconSize = homeVCProfileIconSize
        self.homeVCProfileIconRightMargin = homeVCProfileIconRightMargin
    }
    
    static let duration: TimeInterval = 0.4
    
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    public func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let container = transitionContext.containerView
        let homeVC = transitionContext.viewController(forKey: .to)!
        let profileVC = transitionContext.viewController(forKey: .from)!
        profileVCProfileIconView.isHidden = true
        
        let tmpView: UIView = {
            let tmpView = UIView()
            tmpView.frame = profileVC.view.frame
            tmpView.backgroundColor = profileVC.view.backgroundColor
            tmpView.alpha = 0
            return tmpView
        }()
        
        let tmpProfileIconView: UIView = {
            let tmpProfileIconView = UIView()
            tmpProfileIconView.frame = container.convert(profileVCProfileIconView.frame, from: profileVC.view)
            tmpProfileIconView.backgroundColor = profileVCProfileIconView.backgroundColor
            tmpProfileIconView.layer.cornerRadius = tmpProfileIconView.frame.size.height / 2
            return tmpProfileIconView
        }()
        
        container.frame = profileVC.view.frame
        container.addSubview(homeVC.view)
        container.addSubview(profileVC.view)
        container.addSubview(tmpView)
        container.addSubview(tmpProfileIconView)
        
        // Profile Icon View animation
        UIView.animate(
            withDuration: Self.duration,
            animations: { [unowned self] in
                
                let profileIconViewSize = homeVCProfileIconSize
                let profileIconRightMargin = homeVCProfileIconRightMargin
                
                tmpProfileIconView.layer.cornerRadius = profileIconViewSize / 2
                tmpProfileIconView.snp.makeConstraints {
                    $0.size.equalTo(profileIconViewSize)
                    $0.right.equalToSuperview().offset(-profileIconRightMargin)
                    $0.top.equalTo(homeVC.view.safeAreaInsets.top)
                }
                tmpProfileIconView.superview?.layoutIfNeeded()
                
            }, completion: { _ in
                self.homeVCProfileIconView.isHidden = false
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
                        tmpView.layer.cornerRadius = self.homeVCProfileIconSize / 2
                        
                    }, completion: { _ in

                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            delay: 0,
                            options: .curveEaseOut,
                            animations: {
                                
                                tmpView.snp.remakeConstraints {
                                    $0.top.equalTo(homeVC.view.safeAreaInsets.top)
                                    $0.right.equalToSuperview().offset(-self.homeVCProfileIconRightMargin)
                                    $0.size.equalTo(self.homeVCProfileIconSize)
                                }
                                tmpView.superview?.layoutIfNeeded()
                                
                            }, completion: { _ in
                                tmpView.removeFromSuperview()
                        })
                })
        })
    }
}
