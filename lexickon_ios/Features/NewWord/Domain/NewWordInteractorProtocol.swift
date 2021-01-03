//
//  NewWordInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import LexickonApi

protocol NewWordInteractorProtocol {
    func translate(_ word: String) -> Single<TranslationResultsDTO>
}
