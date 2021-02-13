//
//  AddSearchWordPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
import RxDataSources
import UIComponents
import RxExtensions
import TranslationRepository

typealias OtherTranslationsSectionModel = AnimatableSectionModel<String, OtherTranslationCellModel>
typealias MainTranslationSectionModel = AnimatableSectionModel<String, MainTranslationCellModel>
typealias TranslationReulstRxDataSource = RxTableViewSectionedAnimatedDataSource<MainTranslationSectionModel>

final class AddSearchWordPresenter {
    
    @Injected var interacor: NewWordInteractorProtocol
    
    struct WordTranslationPair {
        let word: String
        let translation: String
    }
    
    struct Input {
        let textForTranslate: Signal<String>
    }
    
    struct Output {
        let sections: Driver<[MainTranslationSectionModel]>
        let isLoading: Driver<Bool>
        let disposables: CompositeDisposable
    }
    
    func configurate(input: Input) -> Output {
        
        let activityIndicator = RxActivityIndicator()
        
        let translationResult = input.textForTranslate
            .flatMap { text -> Driver<TranslationResultsDTO> in
                self.interacor.translate(text)
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let mainTranslationCellModels = translationResult
            .map { result -> [MainTranslationCellModel] in
                [
                    MainTranslationCellModel(
                        translation: result.mainTranslation.translation,
                        text: result.mainTranslation.text
                    )
                ]
            }
            
        let otherTranslationCellModels = translationResult
            .map { translationResult -> [OtherTranslationCellModel] in
                translationResult.otherTranslations.map {
                    OtherTranslationCellModel(
                        translation: $0.translation,
                        text: $0.text
                    )
                }
            }
        
        let didTapAddWord = otherTranslationCellModels
            .flatMap {
                Signal.merge(
                    $0.map { cellModel -> Signal<WordTranslationPair> in
                        cellModel.addWordButtonDidTap
                            .map { _ -> WordTranslationPair in
                                WordTranslationPair(
                                    word: cellModel.text,
                                    translation: cellModel.translation
                                )
                            }
                    }
                )
            }
        
        let didTapAddWordDisposable = didTapAddWord
            .asObservable()
            .flatMap { word -> Single<Void> in
                let wordForAdding = TranslationResultsDTO.Translation(
                    text: word.word,
                    translation: word.translation,
                    pos: .unknown,
                    gender: .unknown
                )
                
                return self.interacor.addWord(wordForAdding)
            }
            .subscribe()
        
        let translationsSections = mainTranslationCellModels
            .map { [MainTranslationSectionModel(model: "MainTranslationSection", items: $0)] }
            .asDriver()
        
        return Output(
            sections: translationsSections,
            isLoading: activityIndicator.asDriver(),
            disposables: CompositeDisposable(disposables: [didTapAddWordDisposable])
        )
    }
}

