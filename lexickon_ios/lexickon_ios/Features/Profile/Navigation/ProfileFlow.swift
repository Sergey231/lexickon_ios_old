//
//  ProfileFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow

enum ProfileStep: Step {
    case profileMainScreen
}

class ProfileFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        rootViewController = root
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ProfileStep else { return .none }
        
        switch step {
        
        case .profileMainScreen:
            return navigateToProfileMainScreen()
        }
    }
    
    private func navigateToProfileMainScreen() -> FlowContributors {
        let profileMainScreenVC = ProfileAssembler.shr.assembler.resolver.resolve(
            ProfileMainScreenViewController.self
        )!
        (root as! UINavigationController).pushViewController(profileMainScreenVC, animated: true)
        return .one(flowContributor: .contribute(withNext: profileMainScreenVC))
    }
}
