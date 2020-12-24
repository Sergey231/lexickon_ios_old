//
//  FromNewWordToHomeAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import UIExtensions

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
        
        let homeVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to
        ) as! HomeViewController
        
        let addSearchWordVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from
        ) as! AddSearchWordViewController
        
        homeVC.view.alpha = 0.6
        
        let tmpView: UIView = {
            let tmpView = UIView()
            tmpView.frame = addSearchWordVC.view.frame
            tmpView.backgroundColor = addSearchWordVC.view.backgroundColor
            tmpView.alpha = 0
            return tmpView
        }()
        
        let tmpHeaderView: UIView = {
            let tmpHeaderView = UIView()
            tmpHeaderView.frame = addSearchWordVC.headerView.frame
            tmpHeaderView.backgroundColor = addSearchWordVC.headerView.backgroundColor
            return tmpHeaderView
        }()
        
        tmpView.addSubview(tmpHeaderView)
        
        let container = transitionContext.containerView
        container.addSubview(homeVC.view)
        container.addSubview(addSearchWordVC.view)
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
                    
                        tmpView.snp.makeConstraints {
                            $0.size.equalTo(homeVC.view.frame.width)
                            $0.bottom.equalToSuperview()
                            $0.width.equalToSuperview()
                        }
                        tmpView.superview?.layoutIfNeeded()

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
                                
                                let rightMargin = (homeVC.addWordButton.frame.size.width - homeVC.addWordButton.circleView.frame.size.width)/2
                                let bottomMargin = (homeVC.addWordButton.frame.size.height - homeVC.addWordButton.circleView.frame.size.height)/2
                                    + Margin.mid
                                
                                tmpView.snp.remakeConstraints {
                                    $0.size.equalTo(homeVC.addWordButton.circleView.frame.size)
                                    $0.right.equalToSuperview().offset(-rightMargin)
                                    $0.bottom.equalToSuperview().offset(-bottomMargin)
                                }
                                tmpHeaderView.snp.remakeConstraints {
                                    $0.edges.equalToSuperview()
                                }
                                tmpView.superview?.layoutIfNeeded()
                                tmpHeaderView.superview?.layoutIfNeeded()
                                
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
