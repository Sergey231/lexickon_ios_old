//
//  ExercisesResultsPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver

final class ExercisesResultPresenter {
    
    struct Input {
        let submitButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let sessionDidFinish: Signal<Void>
    }
    
    func configure(input: Input) -> Output {
        
        let sessionDidFinish = input.submitButtonDidTap
            .map { //[unowned self] _ in
                
            }
        
        return Output(sessionDidFinish: sessionDidFinish)
    }
}
