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
    
    @Injected var exercisesInteractor: ExercisesInteractorProtocol
    
    struct Input {
        let submitButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let sessionDidFinish: Signal<Void>
    }
    
    func configure(input: Input) -> Output {
        
        let sessionDidFinish = input.submitButtonDidTap
            .flatMap { [unowned self] _ in
                exercisesInteractor.saveCurrentSession()
                    .asSignal(onErrorSignalWith: .just(()))
            }
        
        return Output(sessionDidFinish: sessionDidFinish)
    }
}
