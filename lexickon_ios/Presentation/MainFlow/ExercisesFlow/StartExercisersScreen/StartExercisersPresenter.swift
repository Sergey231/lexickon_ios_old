//
//  StartExercisersPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
import LXUIKit

final class StartExercisesPresenter {
    
    @Injected private var lexickonStateInteractor: LexickonStateInteractorProtocol
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func configure(input: Input) -> Output {
        
        let wordsForExerceses = lexickonStateInteractor.wordsForLearing(count: 5)
            .asSignal { error in
                print("❌ \(error.localizedDescription)")
                return .just([])
            }
        
        _ = wordsForExerceses.debug("👨🏻").emit()
        
        return Output()
    }
}
