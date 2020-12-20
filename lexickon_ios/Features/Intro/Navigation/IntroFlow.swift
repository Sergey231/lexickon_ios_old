//
//  IntroFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 16.04.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow

enum IntroStep: Step {
    case firstPage
}

final class IntroFlow: Flow {
    
    var root: Presentable {
        self.rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        self.rootViewController = root
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }

    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? IntroStep else { return .none }
        
        switch step {
            
        case .firstPage:
            return navigateToFirst()
        }
    }
        
    private func navigateToFirst() -> FlowContributors {
        let introVC = IntroAssembler.shr.assembler.resolver.resolve(
            IntroViewController.self
        )!
        return .one(flowContributor: .contribute(withNext: introVC))
    }
}
