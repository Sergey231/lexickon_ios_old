//
//  ExercisesFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxFlow
import UIKit

enum ExercisesStep: Step {
    case startExercises
    case wordViewExercise
    case result
}

final class ExercisesFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    init() {}
    
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
        }
    }
    
    private func navigateToWordViewExercise() -> FlowContributors {
        
        return .none
    }
    
}
