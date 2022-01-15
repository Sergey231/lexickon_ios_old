//
//  SaveExerciseSessionUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class SaveExerciseSessionUseCase {
    
    @Injected private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol
    
    public func configure(_ session: ExercisesSessionEntity) -> Single<Void> {
        exerciseSessionRepository.saveSession(session: session)
    }
}
