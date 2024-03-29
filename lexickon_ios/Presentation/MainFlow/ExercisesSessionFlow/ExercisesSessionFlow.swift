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

enum ExercisesSessionStep: Step {
    case startExercises
    // Можно попробовать передовать по верху
    case exercises
    case home(animated: Bool)
    case result
}

class SessionFlow: Flow {
    
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
            let step = step as? ExercisesSessionStep
        else {
            return .none
        }
        
        switch step {
        case .startExercises:
            return navigateToStartExercises()
        case .exercises:
            return navigateToExercises()
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
    
    private func navigateToExercises() -> FlowContributors {
        guard
            let rootNavigationController = root as? UINavigationController
        else {
            return .none
        }
        let vc: ExercisesContainerViewController = Resolver.resolve()
        rootNavigationController.pushViewController(vc, animated: true)
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
        register { _, args in WordViewExerciseViewController(nextSessionItem: args()) }
        register { WordViewExercisePresenter() }
        register { ExercisesResultPresenter() }
        register { ExercisesResultViewController() }
        register { ExercisesContainerViewController() }.scope(.cached)
        register { ExercisesPresenter() }
        register { ExerciseSessionRepository() as ExerciseSessionRepositoryProtocol }.scope(.cached)
        register { GetExerciseSessionUseCase() }
        register { SyncExerciseSessionUseCase() }
    }
}
