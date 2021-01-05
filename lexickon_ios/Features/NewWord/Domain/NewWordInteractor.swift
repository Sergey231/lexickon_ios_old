//
//  NewWordInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import LexickonApi
import Resolver

final class NewWordInteractor: NewWordInteractorProtocol {
    
    @Injected var translationRepository: TranslationRepositoryProtocol
    
    func translate(_ word: String) -> Single<TranslationResultsDTO> {
        
        let input = RapidApiGoogleTranslateInputDTO(
            text: word,
            rapidApiKey: "bd0047b6c1msh466cb1752c5bae5p17fe30jsne60b241dad74",
            rapidApiHost: "google-translate20.p.rapidapi.com",
            targetLanguage: "ru",
            sourceLanguage: "en"
        )
        
        return translationRepository.translate(input)
    }
}
