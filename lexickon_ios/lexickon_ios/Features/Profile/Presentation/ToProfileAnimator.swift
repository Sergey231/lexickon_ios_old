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
    
    static let duration: TimeInterval = 3
    
    private var isPresenting : Bool
    private let firstViewController: HomeViewController
    private let secondViewController: ProfileMainScreenViewController
    private let profileIconView: UIView
    
    init?(
        isPresenting: Bool,
        firstViewController: HomeViewController,
        secondViewController: ProfileMainScreenViewController,
        profileIconView: UIView
    ) {
        self.isPresenting = isPresenting
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.profileIconView = profileIconView
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
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        else {
            return
        }
        
        guard
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        else {
            return
        }
        
        container.frame = toView.frame
        container.addSubview(toView)

        let tmpProfileIconView = UIView()
        tmpProfileIconView.backgroundColor = .gray
        tmpProfileIconView.layer.cornerRadius = profileIconView.layer.cornerRadius
        tmpProfileIconView.frame = profileIconView.frame
        
        container.addSubview(tmpProfileIconView)
        
        UIView.animate(
            withDuration: Self.duration,
            animations: {
                
                let profileIconViewHeight = ProfileMainScreenViewController.UIConstants.profileIconSize
                
                tmpProfileIconView.layer.cornerRadius = profileIconViewHeight / 2
                tmpProfileIconView.pin
                    .size(profileIconViewHeight)
                    .left(16)
                    .top(container.pin.safeArea.top)
                
            }, completion: { (finished) in
                self.secondViewController.profileIconView.isHidden = false
                tmpProfileIconView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
    
}
