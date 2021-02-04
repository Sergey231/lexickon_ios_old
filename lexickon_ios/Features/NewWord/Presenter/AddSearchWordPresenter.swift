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

typealias TranslationReulstSectionModel = AnimatableSectionModel<String, TranslationResultViewModel>
typealias TranslationReulstRxDataSource = RxTableViewSectionedAnimatedDataSource<TranslationReulstSectionModel>

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
        let sections: Driver<[TranslationReulstSectionModel]>
        let didTapAddWord: Signal<WordTranslationPair>
        let isLoading: Driver<Bool>
        let disposables: CompositeDisposable
    }
    
    func configurate(input: Input) -> Output {
        
        let activityIndicator = RxActivityIndicator()
        
        let translationCellModels = input.textForTranslate
            .flatMap { text -> Driver<[TranslationResultsDTO.Translation]> in
                self.interacor.translate(text)
                    .map { $0.translations }
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorJustReturn: [])
            }
            .map { translations in
                translations.map {
                    TranslationResultViewModel(
                        translation: $0.translation,
                        text: $0.text
                    )
                }
            }
        
        let didTapAddWord = translationCellModels.flatMap {
            Signal.merge($0.map { cellModel -> Signal<WordTranslationPair> in
                cellModel.addWordButtonDidTap
                    .map { _ -> WordTranslationPair in
                        WordTranslationPair(
                            word: cellModel.text,
                            translation: cellModel.translation
                        )
                    }
            })
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
        
        let translationsSections = translationCellModels
            .map { [TranslationReulstSectionModel(model: "TranslationResultSection", items: $0)] }
            .asDriver()
        
        return Output(
            sections: translationsSections,
            didTapAddWord: didTapAddWord,
            isLoading: activityIndicator.asDriver(),
            disposables: CompositeDisposable(disposables: [didTapAddWordDisposable])
        )
    }
}

