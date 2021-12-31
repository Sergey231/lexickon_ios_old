//
//  ExerciseSessionRepository.swift.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift
import RxCocoa

final class ExerciseSessionRepository: ExerciseSessionRepositoryProtocol {
    private var currentSession: ExercisesSessionEntity?
    
    public func saveSession(session: ExercisesSessionEntity) -> Single<Void> {
        currentSession = session
        return .just(())
    }
    
    public func getCurrentSession() -> Single<ExercisesSessionEntity?> {
        return .just(self.currentSession)
    }
}
