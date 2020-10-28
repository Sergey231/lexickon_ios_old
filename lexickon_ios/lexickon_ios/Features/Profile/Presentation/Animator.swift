//
//  Animator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 27.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum PresentationType {

        case present
        case dismiss

        var isPresenting: Bool {
            return self == .present
        }
    }
    
    static let duration: TimeInterval = 1.25
    private let type: PresentationType
    private let firstViewController: HomeViewController
    private let secondViewController: ProfileMainScreenViewController
    private let selectedViewSnapshot: UIView
    
    init?(
        type: PresentationType,
        firstViewController: HomeViewController,
        secondViewController: ProfileMainScreenViewController,
        selectedViewSnapshot: UIView
    ) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedViewSnapshot = selectedViewSnapshot
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        let containerView = transitionContext.containerView
        guard
            let toView = secondViewController.view
        else {
            transitionContext.completeTransition(false)
            return
        }
        transitionContext.completeTransition(true)
    }
    
}
