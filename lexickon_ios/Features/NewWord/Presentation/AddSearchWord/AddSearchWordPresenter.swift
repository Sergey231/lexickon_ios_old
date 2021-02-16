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

enum TranslationCell {
    case Main(MainTranslationCellModel)
    case Other(OtherTranslationCellModel)
    
    var text: String {
        switch self {
        case .Main(let model):
            return model.text
        case .Other(let model):
            return model.text
        }
    }
    
    var translation: String {
        switch self {
        case .Main(let model):
            return model.translation
        case .Other(let model):
            return model.translation
        }
    }
}

typealias TranslationsSection = SectionModel<String, TranslationCell>
typealias TranslationReulstRxDataSource = RxTableViewSectionedReloadDataSource<TranslationsSection>

final class AddSearchWordPresenter {
    
    @Injected var interacor: NewWordInteractorProtocol
    
    struct Input {
        let textForTranslate: Signal<String>
    }
    
    struct Output {
        let sections: Driver<[TranslationsSection]>
        let isLoading: Driver<Bool>
        let disposables: CompositeDisposable
    }
    
    func configurate(input: Input) -> Output {
        
        let activityIndicator = RxActivityIndicator()
        
        let translationResult = input.textForTranslate
            .flatMap { text -> Driver<TranslationResultsDTO> in
                self.interacor.translate(text).debug("🎲")
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let mainTranslationCellModels = translationResult
            .map { result -> [TranslationCell] in
                [
                    TranslationCell.Main(
                        MainTranslationCellModel(
                            translation: result.mainTranslation.translation,
                            text: result.mainTranslation.text
                        )
                    )
                ]
            }
            
        let otherTranslationCellModels = translationResult
            .map { translationResult -> [TranslationCell] in
                translationResult.otherTranslations.map {
                    TranslationCell.Other(
                        OtherTranslationCellModel(
                            translation: $0.translation,
                            text: $0.text
                        )
                    )
                }
            }
        
        let didTapAddWord = otherTranslationCellModels
            .flatMap {
                Signal.merge(
                    $0.map { cellModel -> Signal<TranslationCell> in
                        switch cellModel {
                        
                        case .Main(let model):
                            return model.addWordButtonDidTap
                                .map { _ in cellModel }
                            
                        case .Other(let model):
                            return model.addWordButtonDidTap
                                .map { _ in cellModel }
                        }
                    }
                )
            }
        
        let didTapAddWordDisposable = didTapAddWord
            .asObservable()
            .flatMap { word -> Single<Void> in
                let wordForAdding = TranslationResultsDTO.Translation(
                    text: word.text,
                    translation: word.translation,
                    pos: .unknown,
                    gender: .unknown
                )
                
                return self.interacor.addWord(wordForAdding)
            }
            .subscribe()
        
        let translationsSections = mainTranslationCellModels
            .map { [SectionModel(model: "MainTranslationSection", items: $0)] }
            .asDriver()
        
        return Output(
            sections: translationsSections,
            isLoading: activityIndicator.asDriver(),
            disposables: CompositeDisposable(disposables: [didTapAddWordDisposable])
        )
    }
}

