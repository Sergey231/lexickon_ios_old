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

typealias TranslationReulstSectionModel = AnimatableSectionModel<String, TranslationResultViewModel>
typealias TranslationReulstRxDataSource = RxTableViewSectionedAnimatedDataSource<TranslationReulstSectionModel>

final class AddSearchWordPresenter: PresenterType {
    
    @Injected var interacor: NewWordInteractorProtocol
    struct Input {
        let textForTranslate: Signal<String>
    }
    
    struct Output {
        let sections: Driver<[TranslationReulstSectionModel]>
    }
    
    func configurate(input: Input) -> Output {
        
        let translationSections = input.textForTranslate
            .flatMap { text -> Driver<[TranslationResultsDTO.TranslationItem]> in
                self.interacor.translate(text)
                    .map { $0.translations }
                    .asDriver(onErrorJustReturn: [])
            }
            .map { translations in translations.map { TranslationResultViewModel(translation: $0.translation) } }
            .map { [TranslationReulstSectionModel(model: "TranslationResultSection", items: $0)] }
            .asDriver()
        
        return Output(sections: translationSections)
    }
}

