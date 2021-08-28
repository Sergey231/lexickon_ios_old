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
import WordsRepository

enum ExercisesStep: Step {
    case wordViewExercise
    case home(animated: Bool)
    case lobby
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
        case .wordViewExercise:
            return navigateToExercise()
        case .home(let animated):
            return navigateToHome(animated: animated)
        case .lobby:
            return navigateToLobby()
        }
    }
    
    private func navigateToExercise() -> FlowContributors {
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
        guard
            let nv = root as? UINavigationController
        else {
            return .none
        }
        nv.popToRootViewController(animated: true)
        return .end(forwardToParentFlowWithStep: MainStep.home(animated: false))
    }
    
    private func navigateToLobby() -> FlowContributors {
        return .none
    }
}

// MARK: Registering all needed objects in the DI Container for this Flow
extension Resolver {
    public static func registerExercisesObjects() {
        register { WordViewExerciseViewController() }
        register { WordViewExercisePresenter() }
    }
}
