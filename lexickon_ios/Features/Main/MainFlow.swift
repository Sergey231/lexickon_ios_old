//
//  MainFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.04.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow
import Resolver
import WordsRepository

enum MainStep: Step {
    case home(animated: Bool)
    case profile
    case addWord
    case authorization
}

class MainFlow: Flow {
    
    var root: Presentable {
        self.rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        self.rootViewController = root
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else { return .none }
        
        switch step {
            
        case .home(let animated):
            return navigateToHome(animated: animated)
        case .profile:
            return navigateToProfile()
        case .addWord:
            return navigateToNewWord()
        case .authorization:
            return navigateToAuthorization()
        }
    }
    
    private func navigateToHome(animated: Bool) -> FlowContributors {
        let vc: HomeViewController = Resolver.resolve()
        let navigationController = (root as! UINavigationController)
        navigationController.setViewControllers([vc], animated: animated)
        navigationController.navigationBar.isHidden = true
        navigationController.delegate = vc
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToNewWord() -> FlowContributors {
        let newWordFlow = NewWordFlow(with: rootViewController)
        return .one(flowContributor: .contribute(
            withNextPresentable: newWordFlow,
            withNextStepper: OneStepper(
                withSingleStep: NewWordStep.addSearch
            )
        ))
    }
    
    private func navigateToProfile() -> FlowContributors {
        let profileFlow = ProfileFlow(with: rootViewController)
        return .one(flowContributor: .contribute(
            withNextPresentable: profileFlow,
            withNextStepper: OneStepper(
                withSingleStep: ProfileStep.profileMainScreen
            )
        ))
    }
    
    private func navigateToAuthorization() -> FlowContributors {
        (root as! UINavigationController).delegate = nil
        return .end(forwardToParentFlowWithStep: AppStep.authorization)
    }
}

// MARK: Registering all needed objects in the DI Container for this Flow
extension Resolver {
    public static func registerMainObjects() {
        register { HomeViewController() }
        register { HomePresenter() }
        register { MainInteractor() as MainInteractorProtocol }
        register { WordsRepositoryMock() as WordsRepositoryProtocol }
    }
}
