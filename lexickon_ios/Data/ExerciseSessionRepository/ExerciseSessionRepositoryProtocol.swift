//
//  ExerciseSessionRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift
 

protocol ExerciseSessionRepositoryProtocol {
    func saveSession(session: ExercisesSessionEntity) -> Single<Void>
    func getCurrentSession() -> Single<ExercisesSessionEntity?>
}
