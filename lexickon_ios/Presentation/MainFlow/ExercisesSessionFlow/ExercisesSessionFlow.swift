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

enum ExercisesSessionStep: Step {
    case startExercises
    case wordViewExercise
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
        case .wordViewExercise:
            return navigateToWordViewExercise()
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
    
    private func navigateToWordViewExercise() -> FlowContributors {
        
        let vc: ExercisesContainerViewController = Resolver.resolve()
        var exercisesNavigationController = UINavigationController()
        guard
            let rootNavigationController = root as? UINavigationController
        else {
            return .none
        }
        
        if !(rootNavigationController.viewControllers.last is ExercisesContainerViewController) {
            exercisesNavigationController = vc.exercisesNavigationController
            rootNavigationController.pushViewController(vc, animated: true)
        }
        let wordViewViewController: WordViewExerciseViewController = Resolver.resolve()
        exercisesNavigationController.setViewControllers([wordViewViewController], animated: true)
        
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
        register { ExercisesContainerViewController() }
        register { ExercisesPresenter() }
    }
}
