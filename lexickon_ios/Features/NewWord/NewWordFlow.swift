//
//  NewWordFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow
import Resolver

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
        let vc: AddSearchWordViewController = Resolver.resolve()
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToWordCard() -> FlowContributors {
        return .none
    }
    
    private func navigateToHome() -> FlowContributors {
        rootViewController.popToRootViewController(animated: true)
        return .none
    }
}

extension Resolver {
    public static func registerNewWordObjects() {
        register { AddSearchWordViewController() }
        register { AddSearchWordPresenter() }
        register { NewWordInteractor() as NewWordInteractorProtocol }
        register { TranslationRepository() as TranslationRepositoryProtocol }
        register { KeyValueRepository() as KeyValueRepositoryProtocol }
    }
}
