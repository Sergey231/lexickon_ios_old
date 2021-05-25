//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 25.05.2021.
//

import RxSwift
import LexickonApi

public protocol WordsStateRepositoryProtocol {
    func wordsState() -> Single<WordsState>
}
