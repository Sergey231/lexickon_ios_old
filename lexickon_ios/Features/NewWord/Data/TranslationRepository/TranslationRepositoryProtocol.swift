//
//  TranslationRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift

protocol TranslationRepositoryProtocol {
    func translate(_ input: RapidApiGoogleTranslateInputDTO) -> Single<TranslationResultsDTO>
}

struct TranslationResultsDTO {
    var rapidApiGoogleTranslate: RapidApiGoogleTranslateResultDTO
}
