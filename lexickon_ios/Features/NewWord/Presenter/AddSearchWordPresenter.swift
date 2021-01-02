//
//  AddSearchWordPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver

final class AddSearchWordPresenter: PresenterType {
    
    @Injected var interacor: NewWordInteractorProtocol
    struct Input {
        let translate: Signal<String>
    }
    
    struct Output {
        let translation: Signal<String>
    }
    
    func configurate(input: Input) -> Output {
        
        let translation = input.translate
            .asSignal()
            .flatMap { text -> Signal<String> in
                return self.interacor.translate(text)
            }
            .asSignal()
        
        Output(translation: translation)
    }
}

