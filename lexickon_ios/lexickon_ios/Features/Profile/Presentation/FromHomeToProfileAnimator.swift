//
//  Animator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 27.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout

final class FromHomeToProfileAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 1
    
    private var navigationControllerOperation : UINavigationController.Operation
    private let fromViewController: UIViewController
    private let toViewController: UIViewController
    
    init?(
        navigationControllerOperation: UINavigationController.Operation,
        fromViewController: UIViewController,
        toViewController: UIViewController
    ) {
        self.navigationControllerOperation = navigationControllerOperation
        self.fromViewController = fromViewController
        self.toViewController = toViewController
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        switch navigationControllerOperation {
        case .push:
            animateFromHomeToProfile(
                withFromVC: fromViewController as! HomeViewController,
                toVC: toViewController as! ProfileMainScreenViewController,
                transitionContext: transitionContext
            )
        case .pop:
            animateFromProfileToHome(
                withFromVC: fromViewController as! ProfileMainScreenViewController,
                toVC: toViewController as! HomeViewController,
                transitionContext: transitionContext
            )
        case .none:
            return
        @unknown default:
            return
        }
    }
    
    private func animateFromHomeToProfile(
        withFromVC homeVC: HomeViewController,
        toVC profileVC: ProfileMainScreenViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let container = transitionContext.containerView
        
        guard
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else {
            return
        }
        
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
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
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
    
    private func animateFromProfileToHome(
        withFromVC profileVC: ProfileMainScreenViewController,
        toVC homeVC: HomeViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        let container = transitionContext.containerView
        
        guard
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else {
            return
        }
        
        container.frame = profileVC.view.frame
        
        let tmpView = UIView()
        tmpView.frame = profileVC.view.frame
        tmpView.backgroundColor = profileVC.view.backgroundColor
        tmpView.alpha = 0
        
        let tmpProfileIconView = UIView()
        tmpProfileIconView.frame = profileVC.profileIconView.frame
        
        container.addSubview(profileVC.view)
        container.addSubview(profileVC.view)
        container.addSubview(tmpView)
        container.addSubview(tmpProfileIconView)
        
        UIView.animate(
            withDuration: Self.duration,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: .curveEaseInOut,
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
        
        // 1
        UIView.animate(
            withDuration: Self.duration/3,
            animations: { tmpView.alpha = 1 },
            completion: { _ in
                // 2
                UIView.animate(
                    withDuration: Self.duration/3,
                    delay: 0,
                    options: .curveEaseIn,
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
                                    .top(toView.pin.safeArea.top)
                                    .right(HomeViewController.UIConstants.profileIconRightMargin)
                                    .size(HomeViewController.UIConstants.profileIconSize)
                            }, completion: { _ in
                                tmpView.removeFromSuperview()
                        })
                })
        })
    }
}
