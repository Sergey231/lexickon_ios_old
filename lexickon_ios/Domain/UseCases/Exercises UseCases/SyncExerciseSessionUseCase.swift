//
//  SyncExerciseSessionUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.03.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

// UseCase для сохранения состояния слов в БД, на сервере
final class SyncExerciseSessionUseCase {
    
    @Injected private var wordsRepository: WordsRepositoryProtocol
    
    public struct Input {
        let session: ExercisesSessionEntity
    }
    
    func configure(_ input: Input) -> Observable<Void> {
        let lxWordCreates = input.session.sessionWords.map {
            LxWordCreate(
                studyWord: $0.word.studyWord,
                translates: $0.word.translates,
                image: $0.word.image
            )
        }
        return wordsRepository.add(lxWordCreates)
            .map { _ in () }
            .asObservable()
    }
}
