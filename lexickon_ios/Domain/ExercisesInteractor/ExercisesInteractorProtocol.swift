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

public enum ExerciseEntity {
    case wordView
}

public protocol ExercisesInteractorProtocol {
    func getExercisesSession(with words: [WordEntity]) -> Single<ExercisesSessionEntity>
}
