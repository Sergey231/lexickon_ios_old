//
//  WordRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 05.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift

public protocol WordsRepositoryProtocol {
    
    func words(per: Int, page: Int) -> Single<LxPage<LxWordList>>
    func word(by id: String) -> Single<LxWordGet>
    func add(_ words: [LxWordCreate]) -> Single<[LxWordGet]>
}
