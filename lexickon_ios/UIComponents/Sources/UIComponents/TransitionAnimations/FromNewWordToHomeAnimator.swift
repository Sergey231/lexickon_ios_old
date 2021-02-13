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
import Assets

public final class FromNewWordToHomeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let addSearchWordVCHeaderViewFrame: CGRect
    private let homeVCAddWordButton: AddSearchWordButton
    private let addSearchWordVCHeaderView: UIView
    
    public init(
        addSearchWordVCHeaderViewFrame: CGRect,
        homeVCAddWordButton: AddSearchWordButton,
        addSearchWordVCHeaderView: UIView
    ) {
        self.addSearchWordVCHeaderViewFrame = addSearchWordVCHeaderViewFrame
        self.homeVCAddWordButton = homeVCAddWordButton
        self.addSearchWordVCHeaderView = addSearchWordVCHeaderView
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
        
        let homeVC = transitionContext.viewController(forKey: .to)!
        let addSearchWordVC = transitionContext.viewController(forKey: .from)!
        
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
            tmpHeaderView.frame = addSearchWordVCHeaderViewFrame
            tmpHeaderView.backgroundColor = addSearchWordVCHeaderView.backgroundColor
            return tmpHeaderView
        }()
        
        tmpView.addSubview(tmpHeaderView)
        
        let container = transitionContext.containerView
        container.addSubview(homeVC.view)
        container.addSubview(addSearchWordVC.view)
        container.addSubview(tmpView)
        
        let homeVCAddWordButton = self.homeVCAddWordButton
        
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
                        tmpView.backgroundColor = Asset.Colors.mainBG.color
                        tmpView.layer.cornerRadius = homeVCAddWordButton.circleView.frame.size.height / 2
                        tmpHeaderView.layer.cornerRadius = homeVCAddWordButton.circleView.frame.size.height / 2
                        homeVC.view.alpha = 0.8
                        
                    }, completion: { _ in

                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            delay: 0,
                            options: .curveEaseOut,
                            animations: {
                                
                                let rightMargin = (homeVCAddWordButton.frame.size.width - homeVCAddWordButton.circleView.frame.size.width)/2
                                let bottomMargin = (homeVCAddWordButton.frame.size.height - homeVCAddWordButton.circleView.frame.size.height)/2
                                    + Margin.mid
                                
                                tmpView.snp.remakeConstraints {
                                    $0.size.equalTo(homeVCAddWordButton.circleView.frame.size)
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
