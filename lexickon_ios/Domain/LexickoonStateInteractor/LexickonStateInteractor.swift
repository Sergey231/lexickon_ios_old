//
//  WordInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift
import Resolver
import WordsRepository
import LexickonStateEntity

final class LexickonStateInteractor: LexickonStateInteractorProtocol {
    
    @Injected var wordRepository: WordsRepositoryProtocol
    
    private let disposeBag = DisposeBag()
    private let updateWordsTimer = Observable<Int>.interval(
        .seconds(2),
        scheduler: ConcurrentDispatchQueueScheduler(qos: .background)
    )
    
    init() {
        self.configureWordsUpdating()
    }
    
    func state() -> Single<LexickonStateEntity> {
        .error(LxHTTPObject.Error.unknown)
    }
    
    func words(per: Int, page: Int) -> Single<LxPage<WordEntity>> {
        wordRepository.words(per: per, page: page)
            .map { page -> LxPage<WordEntity> in
                
                let metadata = LxPage<WordEntity>.Metadata(
                    page: page.metadata.page,
                    per: page.metadata.per,
                    total: page.metadata.total
                )
                
                let items: [WordEntity] = page.items.map { WordEntity(withLxWordList: $0) }
                
                return LxPage<WordEntity>.init(
                    metadata: metadata,
                    items: items
                )
            }
    }
    
    func word(by id: String) -> Single<WordEntity> {
        wordRepository.word(by: id)
            .map { WordEntity(withLxWordGet: $0) }
    }
    
    private func configureWordsUpdating() {
        updateWordsTimer
            .debug("⚽️")
            .subscribe()
            .disposed(by: disposeBag)
            
    }
}
