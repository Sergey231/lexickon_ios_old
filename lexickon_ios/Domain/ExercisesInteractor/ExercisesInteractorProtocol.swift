//
//  ExercisesInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.08.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation
import LexickonStateEntity
import RxSwift

public protocol ExercisesInteractorProtocol {
    func createExerciseSession(with words: [WordEntity]) -> Single<ExercisesSessionEntity>
    var currentSession: ExercisesSessionEntity? { get }
}
