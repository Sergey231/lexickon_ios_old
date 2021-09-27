//
//  WordInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import LexickonApi
// import LexickonStateEntity

protocol LexickonStateInteractorProtocol {
    func state() -> Single<LexickonStateEntity>
    func words(per: Int, page: Int) -> Single<LxPage<WordEntity>>
    func word(by id: String) -> Single<WordEntity>
    func wordsForExercisesSession(count: Int) -> Single<[WordEntity]>
}
