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

typealias TranslationReulstSectionModel = AnimatableSectionModel<String, TranslationResultViewModel>
typealias TranslationReulstRxDataSource = RxTableViewSectionedAnimatedDataSource<TranslationReulstSectionModel>

final class AddSearchWordPresenter: PresenterType {
    
    @Injected var interacor: NewWordInteractorProtocol
    struct Input {
        let translate: Signal<String>
    }
    
    struct Output {
        let sections: Driver<[TranslationReulstSectionModel]>
    }
    
    func configurate(input: Input) -> Output {
        
        let translationSections = input.translate
            .asSignal()
            .flatMap { text -> Driver<String> in
                return self.interacor.translate(text)
                    .map { $0.rapidApiGoogleTranslate.data.translation }
                    .asDriver { error -> Driver<String> in
                        .just("")
                    }
            }
            .map { TranslationResultViewModel(translation: $0) }
            .map { [TranslationReulstSectionModel(model: "TranslationResultSection", items: [$0])] }
            .asDriver()
        
        return Output(sections: translationSections)
    }
}

