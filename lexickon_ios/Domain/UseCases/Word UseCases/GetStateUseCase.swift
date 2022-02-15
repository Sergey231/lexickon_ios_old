//
//  GetStateUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
import LexickonApi

final class GetStateUseCase {
    
    @Injected private var wordsRepository: WordsRepositoryProtocol
    @Injected private var stateRepository: WordsStateRepositoryProtocol
    
    public struct Input {
        let updateState: Signal<Void>
        let updateEverySeconds: Int = 60
    }
    
    public func configure(_ input: Input) -> Driver<LexickonStateEntity> {
        
        let state = input.updateState
            .asObservable()
            .flatMap { _ -> Observable<LxWordsState> in
                self.stateRepository.wordsState().asObservable()
            }
            .map { lxState -> LexickonStateEntity in
                LexickonStateEntity(
                    fireWordsCount: lxState.fireWordsCount,
                    readyWordsCount: lxState.readyWordsCount,
                    newWordsCount: lxState.newWordsCount,
                    waitingWordsCount: lxState.waitingWordsCount
                )
            }
            .asDriver(onErrorJustReturn: .empty())
        
        return state
    }
}
