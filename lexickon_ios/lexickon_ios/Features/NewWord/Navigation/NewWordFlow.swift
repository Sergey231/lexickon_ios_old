//
//  NewWordFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow

enum NewWordStep: Step {
    case addSearch
    case wordCard
    case toHome
}

final class NewWordFlow: Flow {
    
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
        guard let step = step as? NewWordStep else { return .none }
        
        switch step {
        case .addSearch:
            return navigateToAddSearchWord()
        case .wordCard:
            return navigateToWordCard()
        case .toHome:
            return navigateToHome()
        }
    }
    
    private func navigateToAddSearchWord() -> FlowContributors {
        let addSerchWordVC = NewWordAssembler.shr.assembler.resolver.resolve(
            AddSearchWordViewController.self
        )!
        rootViewController.pushViewController(addSerchWordVC, animated: true)
        return .one(flowContributor: .contribute(withNext: addSerchWordVC))
    }
    
    private func navigateToWordCard() -> FlowContributors {
        return .none
    }
    
    private func navigateToHome() -> FlowContributors {
        DI.shr.appContainer.resetObjectScope(.newWordScopeObject)
        rootViewController.popToRootViewController(animated: true)
        return .none
    }
}
