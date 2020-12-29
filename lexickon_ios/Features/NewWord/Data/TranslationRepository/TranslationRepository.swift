//
//  TranslationRepository.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import Foundation
import Alamofire

final class TranslationRepository: TranslationRepositoryProtocol {
    
    func translate(_ text: String) -> Single<String> {
        
        let url = "https://google-translate20.p.rapidapi.com/translate?text=\(text)&tl=ru&sl=en"
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": "bd0047b6c1msh466cb1752c5bae5p17fe30jsne60b241dad74",
            "x-rapidapi-host" : "google-translate20.p.rapidapi.com"
        ]
        
        return Single.create { single -> Disposable in
            
            AF.request(url, headers: headers) { res in
                print(res)
            }
            
            return Disposables.create()
        }
    }
}
