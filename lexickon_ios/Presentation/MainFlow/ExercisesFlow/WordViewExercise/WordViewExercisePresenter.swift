//
//  WordViewExercisePresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 20.08.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
import LXUIKit

final class WordViewExercisePresenter {
    
    struct Input {
        let exerciseDidDone: Signal<Void>
    }
    
    struct Output {
      
    }
    
    func configure(input: Input) -> Output {
        
        input.exerciseDidDone.debug("👨🏻").emit()
        
        return Output()
    }
}
