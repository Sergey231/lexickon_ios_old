//
//  GetExerciseSessionUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class GetExerciseSessionUseCase {
    
    @Injected private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol
    
    public func configure() -> ExercisesSessionEntity? {
        exerciseSessionRepository.getCurrentSession()
    }
}
