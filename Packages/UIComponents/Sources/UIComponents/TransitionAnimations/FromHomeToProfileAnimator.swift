//
//  Animator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 27.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit

public final class FromHomeToProfileAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let profileVCProfileIconView: UIView
    private let profileVCProfileIconViewSize: CGFloat
    private let homeVCProfileIconView: UIView
    private let profileIconTopMargin: CGFloat
    
    public init(
        profileVCProfileIconView: UIView,
        profileVCProfileIconViewSize: CGFloat,
        homeVCProfileIconView: UIView,
        profileIconTopMargin: CGFloat
    ) {
        self.profileVCProfileIconView = profileVCProfileIconView
        self.profileVCProfileIconViewSize = profileVCProfileIconViewSize
        self.homeVCProfileIconView = homeVCProfileIconView
        self.profileIconTopMargin = profileIconTopMargin
    }
    
    static let duration: TimeInterval = 0.8
    
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    public func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let homeVC = transitionContext.viewController(forKey: .from)!
        let profileVC = transitionContext.viewController(forKey: .to)!
        profileVC.view.isHidden = true
        profileVCProfileIconView.isHidden = true
        
        
        let tmpView: UIView = {
            let tmpView = UIView()
            tmpView.frame = homeVCProfileIconView.frame
            tmpView.backgroundColor = profileVC.view.backgroundColor
            tmpView.layer.cornerRadius = tmpView.frame.size.height / 2
            return tmpView
        }()
        
        let tmpProfileIconView: UIView = {
            let tmpProfileIconView = UIView()
            tmpProfileIconView.frame = homeVCProfileIconView.frame
            tmpProfileIconView.backgroundColor = .gray
            tmpProfileIconView.layer.cornerRadius = homeVCProfileIconView.layer.cornerRadius
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
            animations: { [self] in

                let profileIconViewSize = self.profileVCProfileIconViewSize
                let profileIconTopMargin = self.profileIconTopMargin
                    + profileVC.view.safeAreaInsets.top

                tmpProfileIconView.layer.cornerRadius = profileIconViewSize / 2
                tmpProfileIconView.snp.makeConstraints{
                    $0.size.equalTo(profileIconViewSize)
                    $0.top.equalTo(profileIconTopMargin)
                    $0.centerX.equalToSuperview()
                }
                tmpProfileIconView.superview?.layoutIfNeeded()

            }, completion: { _ in
                self.profileVCProfileIconView.isHidden = false
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
