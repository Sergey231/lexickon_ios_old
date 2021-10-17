//
//  ExercisesFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxFlow
import UIKit
import Resolver

enum ExercisesStep: Step {
    case startExercises
    case wordViewExercise
    case result
    case exit
}

final class ExercisesFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController: UINavigationController
    private let exercisesNavigationController = UINavigationController()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
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
        case .startExercises:
            return .end(forwardToParentFlowWithStep: SessionStep.startExercises)
        case .wordViewExercise:
            return navigateToWordViewExercise()
        case .result:
            return .end(forwardToParentFlowWithStep: SessionStep.result)
        case .exit:
            return .end(forwardToParentFlowWithStep: SessionStep.home(animated: true))
        }
    }
    
    private func navigateToWordViewExercise() -> FlowContributors {
        let vc: ExercisesContainerViewController = Resolver.resolve()
        guard
            let nv = root as? UINavigationController
        else {
            return .none
        }
        
        nv.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
}
