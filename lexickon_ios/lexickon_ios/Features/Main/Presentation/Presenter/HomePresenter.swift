//
//  MainViewPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxDataSources
import RxCocoa
import LexickonApi
import RxDataSources

final class HomePresenter: PresenterType {
    
    private let mainInteractor: MainInteractorProtocol
    
    typealias HomeWordSectionModel = AnimatableSectionModel<String, HomeWordViewModel>
    
    init(mainInteractor: MainInteractorProtocol) {
        self.mainInteractor = mainInteractor
    }
    
    struct Input {
        let needLoadNextWordsPage: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[HomeWordSectionModel]>
    }
    
    private var loadedWordsCount: Int = 10
    private var pagesCount: Int = 1
    
    func configurate(input: Input) -> Output {
        
        let words = input.needLoadNextWordsPage
            .startWith(())
            .flatMapLatest { _ -> Driver<[LxWordList]> in
                self.mainInteractor.words(
                    per: self.loadedWordsCount,
                    page: self.pagesCount
                )
                    .map { $0.items }
                    .asDriver(onErrorJustReturn: [])
                .do(onNext: {
                    self.loadedWordsCount += $0.count
                    self.pagesCount += 1
                })
            }
        
        let sections = words
            .map { words -> [HomeWordSectionModel] in
                var fireWords: [HomeWordViewModel] = []
                var readyWords: [HomeWordViewModel] = []
                var newWords: [HomeWordViewModel] = []
                var waitingWords: [HomeWordViewModel] = []
                words.forEach {
                    switch $0.studyType {
                    case .fire:
                        fireWords.append(HomeWordViewModel(word: $0.studyWord))
                    case .ready:
                        readyWords.append(HomeWordViewModel(word: $0.studyWord))
                    case .new:
                        newWords.append(HomeWordViewModel(word: $0.studyWord))
                    case .waiting:
                        waitingWords.append(HomeWordViewModel(word: $0.studyWord))
                    }
                }
                
                let fireWordsSection = HomeWordSectionModel(
                    model: "fire",
                    items: fireWords
                )
                
                let readyWordsSection = HomeWordSectionModel(
                    model: "ready",
                    items: readyWords
                )
                let newWordsSection = HomeWordSectionModel(
                    model: "new",
                    items: newWords
                )
                let waitingWordsSection = HomeWordSectionModel(
                    model: "waiting",
                    items: waitingWords
                )
                
                return [
                    fireWordsSection,
                    readyWordsSection,
                    newWordsSection,
                    waitingWordsSection
                ]
            }
        
        
        return Output(sections: sections)
    }
}
