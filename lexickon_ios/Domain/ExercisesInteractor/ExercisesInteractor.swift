//
//  ExercisesInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 01.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation
import LexickonStateEntity
import RxSwift
import LexickonApi

public class ExercisesInteractor: ExercisesInteractorProtocol {
    
    public func getExercisesSession(with words: [WordEntity]) -> Single<ExercisesSessionEntity> {
        let exercisesSessionEntity = ExercisesSessionEntity(
            words: words,
            exercises: [.wordView]
        )
        return .just(exercisesSessionEntity)
    }
}
