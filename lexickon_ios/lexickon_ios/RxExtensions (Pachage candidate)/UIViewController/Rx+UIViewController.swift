//
//  Reactive+UIViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
                .map { _ in () }
        )
    }
    
    var viewDidAppear: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
                .map { _ in () }
        )
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIViewController.viewWillLayoutSubviews))
                .map { _ in () }
        )
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
                .map { _ in () }
        )
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
                .map { _ in () }
        )
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        ControlEvent(
            events: base.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
                .map { _ in () }
        )
    }
    
    var didPop: ControlEvent<Void> {
        
        let source = viewDidAppear
            .asObservable()
            .flatMap { [weak base] _ -> Observable<Void> in
                
                guard let navigationController = base?.navigationController else {
                    return .empty()
                }
                
                return navigationController.rx
                    .willShow
                    .take(1)
                    .map { [weak base, weak navigationController] vc, _ -> Bool in
                        
                        guard
                            let base = base,
                            let nc = navigationController
                        else {
                            return false
                        }
                        
                        let viewControllers = nc.viewControllers
                        
                        return !viewControllers.contains(base) &&
                            viewControllers.firstIndex(of: vc) == viewControllers.endIndex - 1
                        
                    }.filter { $0 }
                    .map { _ in () }
            }
        
        return ControlEvent(events: source)
    }
    
    var didShow: ControlEvent<Void> {
        
        guard let nv = base.navigationController else {
            return ControlEvent(events: Observable.empty())
        }
        
        let source = nv.rx.willShow
            .filter { base == $0.viewController }
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
}
