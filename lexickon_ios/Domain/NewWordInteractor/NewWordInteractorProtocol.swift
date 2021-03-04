//
//  NewWordInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import TranslationRepository

protocol NewWordInteractorProtocol {
    func translate(_ text: String) -> Single<TranslationResultsDTO>
    func addWord(_ word: TranslationResultsDTO.Translation) -> Single<Void>
}
