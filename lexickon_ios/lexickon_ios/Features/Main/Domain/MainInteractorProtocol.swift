//
//  WordInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import LexickonApi

protocol MainInteractorProtocol {
    
    func words(per: Int, page: Int) -> Single<PageObject<WordListObject>>
}
