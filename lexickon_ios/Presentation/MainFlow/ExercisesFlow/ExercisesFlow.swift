//
//  ExercisesFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.08.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxFlow

import UIKit
import RxFlow
import Resolver
// import WordsRepository
// import LexickonStateEntity

enum ExercisesStep: Step {
    case startExerceses
    case wordViewExercise
    case home(animated: Bool)
    case result
}

class ExercisesFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        rootViewController = root
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard
            let step = step as? ExercisesStep
        else {
            return .none
        }
        
        switch step {
        case .startExerceses:
            return navigateToStartExercises()
        case .wordViewExercise:
            return navigateToViewExercise()
        case .home(let animated):
            return navigateToHome(animated: animated)
        case .result:
            return navigateToResult()
        }
    }
    
    private func navigateToStartExercises() -> FlowContributors {
        let vc: StartExercisesViewController = Resolver.resolve()
        guard
            let nv = root as? UINavigationController
        else {
            return .none
        }
        
        nv.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToViewExercise() -> FlowContributors {
        let vc: WordViewExerciseViewController = Resolver.resolve()
        guard
            let nv = root as? UINavigationController
        else {
            return .none
        }
        
        nv.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToHome(animated: Bool) -> FlowContributors {
        .end(forwardToParentFlowWithStep: MainStep.home(animated: animated))
    }
    
    private func navigateToResult() -> FlowContributors {
        let vc: ExercisesResultViewController = Resolver.resolve()
        guard
            let nv = root as? UINavigationController else {
                return .none
            }
        nv.setViewControllers([vc], animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
}

// MARK: Registering all needed objects in the DI Container for this Flow
extension Resolver {
    public static func registerExercisesObjects() {
        register { StartExercisesViewController() }
        register { StartExercisesPresenter() }
        register { WordViewExerciseViewController() }
        register { WordViewExercisePresenter() }
        register { ExercisesInteractor() as ExercisesInteractorProtocol }.scope(.cached)
        register { ExercisesResultPresenter() }
        register { ExercisesResultViewController() }
    }
}
