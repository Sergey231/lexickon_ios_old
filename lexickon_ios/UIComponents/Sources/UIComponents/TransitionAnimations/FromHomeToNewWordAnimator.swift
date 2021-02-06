//
//  ToNewWordAnimator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import UIExtensions
import Assets

public final class FromHomeToNewWordAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let headerViewHeight: CGFloat
    private let addWordButton: AddWordButtonView
    
    public init(
        headerViewHeight: CGFloat,
        addWordButton: AddWordButtonView
    ) {
        self.headerViewHeight = headerViewHeight
        self.addWordButton = addWordButton
    }
    
    static let duration: TimeInterval = 0.6
    
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    public func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let homeVC = transitionContext.viewController(forKey: .from)!
        let addSearchWordVC = transitionContext.viewController(forKey: .to)!
        addSearchWordVC.view.isHidden = true
        
        guard let circleViewFrame = addWordButton.circleView.globalFrame else {
            return
        }
        let tmpView: UIView = {
            let tmpView = UIView()
            tmpView.frame = circleViewFrame
            tmpView.backgroundColor = .white
            tmpView.layer.cornerRadius = circleViewFrame.size.height / 2
            tmpView.clipsToBounds = true
            tmpView.backgroundColor = Asset.Colors.mainBG.color
            return tmpView
        }()
        
        let tmpAddSearchWordHeaderView: UIView = {
            let tmpAddSearchWordHeaderView = UIView()
            tmpAddSearchWordHeaderView.backgroundColor = addWordButton.circleView.backgroundColor
            tmpAddSearchWordHeaderView.frame = CGRect(
                x: 0,
                y: 0,
                width: circleViewFrame.width,
                height: circleViewFrame.height
            )
            tmpAddSearchWordHeaderView.layer.cornerRadius = circleViewFrame.size.height / 2
            return tmpAddSearchWordHeaderView
        }()
        
        tmpView.addSubview(tmpAddSearchWordHeaderView)
        
        let container = transitionContext.containerView
        container.frame = addSearchWordVC.view.frame
        container.addSubview(addSearchWordVC.view)
        container.addSubview(tmpView)
        
        // 1
        UIView.animate(
            withDuration: Self.duration/3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                
                tmpView.snp.makeConstraints {
                    $0.width.equalToSuperview()
                    $0.bottom.equalToSuperview()
                    $0.height.equalTo(addSearchWordVC.view.frame.width)
                }
                
                tmpAddSearchWordHeaderView.snp.makeConstraints {
                    $0.width.equalToSuperview()
                    $0.top.equalToSuperview()
                    $0.height.equalTo(self.headerViewHeight)
                }
                
                tmpView.superview?.layoutIfNeeded()
                tmpAddSearchWordHeaderView.superview?.layoutIfNeeded()
                tmpAddSearchWordHeaderView.layer.cornerRadius = 0
                homeVC.view.alpha = 0.7

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
                        tmpView.backgroundColor = .white
                    },
                    completion: { _ in

                        addSearchWordVC.view.isHidden = false
                        // 3
                        UIView.animate(
                            withDuration: Self.duration/3,
                            animations: { tmpView.alpha = 0 },
                            completion: { _ in
                                homeVC.view.alpha = 1
                                tmpAddSearchWordHeaderView.removeFromSuperview()
                                tmpView.removeFromSuperview()
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        })
                })
        })
    }
}
