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
// import WordsRepository
// import LexickonStateEntity

enum MainStep: Step {
    case home(animated: Bool)
    case profile
    case addWord
    case authorization
    case wordCard(WordEntity)
    case exercises
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
        guard
            let step = step as? MainStep
        else {
            return .none
        }
        
        switch step {
            
        case .home(let animated):
            return navigateToHome(animated: animated)
        case .profile:
            return navigateToProfile()
        case .addWord:
            return navigateToNewWord()
        case .authorization:
            return navigateToAuthorization()
        case .wordCard(let word):
            return navigateToWordCard(word: word)
        case .exercises:
            return navigationToExercises()
        }
    }
    
    private func navigateToHome(animated: Bool) -> FlowContributors {
        let vc: HomeViewController = Resolver.resolve()
        let navigationController = (root as! UINavigationController)
        navigationController.setViewControllers([vc], animated: animated)
        navigationController.navigationBar.isHidden = true
        navigationController.setNavigationBarHidden(true, animated: false)
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
    
    private func navigateToWordCard(word: WordEntity) -> FlowContributors {
        let wordCardFlow = WordCardFlow(with: rootViewController)
        return .one(flowContributor: .contribute(
            withNextPresentable: wordCardFlow,
            withNextStepper: OneStepper(
                withSingleStep: WordCardStep.word(word)
            )
        ))
    }
    
    private func navigationToExercises() -> FlowContributors {
        let exercisesFlow = SessionFlow(with: rootViewController)
        let navigationController = (root as! UINavigationController)
        navigationController.navigationBar.isHidden = false
        return .one(flowContributor: .contribute(
            withNextPresentable: exercisesFlow,
            withNextStepper: OneStepper(withSingleStep: ExercisesSessionStep.startExercises)
        ))
    }
}

// MARK: Registering all needed objects in the DI Container for this Flow
extension Resolver {
    public static func registerMainObjects() {
        register { HomeViewController() }
        register { HomePresenter() }
        register { WordsRepository() as WordsRepositoryProtocol }
        register { WordsStateRepository() as WordsStateRepositoryProtocol }
        register { GetStateUseCase() }
        
        register { LexickonStateInteractor() as LexickonStateInteractorProtocol }
    }
}
