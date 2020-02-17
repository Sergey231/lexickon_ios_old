//
//  IntroViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import PinLayout

final class IntroPageViewController: UIPageViewController {
    
    fileprivate var numberOfViewControllers: Int {
        return images.count
    }
    
    fileprivate let images: [UIImage] = [#imageLiteral(resourceName: "art1"),
                                         #imageLiteral(resourceName: "art2"),
                                         #imageLiteral(resourceName: "art3")]
    
    // MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        dataSource = self
        
        if let viewController = showViewController(at: 0) {
            set(viewControllers: [viewController])
        }
    }
    
    func showViewController(at index: Int) -> IntroViewController? {
        guard index != NSNotFound, index >= 0, index < numberOfViewControllers else { return nil }
        let viewController = DI.shr.assembler.resolver.resolve(IntroViewController.self)!
        viewController.index = index
        viewController.image = images[index]
        viewController.isLast = index == 2
        
        return viewController
    }
    
    func set(viewControllers: [UIViewController]) {
        setViewControllers(
            viewControllers,
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
}

// MARK:- UIPageViewControllerDataSource
extension IntroPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        var index = (viewController as! IntroViewController).index
        index -= 1
        return showViewController(at: index)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        var index = (viewController as! IntroViewController).index
        index += 1
        
        return showViewController(at: index)
    }
}
