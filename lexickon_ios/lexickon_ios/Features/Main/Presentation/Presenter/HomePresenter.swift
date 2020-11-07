//
//  MainViewPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxDataSources
import RxCocoa

final class HomePresenter: PresenterType {
    
    private let mainInteractor: MainInteractorProtocol
    
    init(mainInteractor: MainInteractorProtocol) {
        self.mainInteractor = mainInteractor
    }
    
    struct Output {
        let models: Driver<[HomeWordViewModel]>
    }
    
    func configurate() -> Output {
        
        _ = mainInteractor.words(per: 2, page: 1)
            .debug("😀")
            .subscribe()
        
        return Output(
            models: .just(
                        [
                            HomeWordViewModel(word: "Тест"),
                            HomeWordViewModel(word: "Тест2"),
                            HomeWordViewModel(word: "Тест3"),
                            HomeWordViewModel(word: "Тест4")
                        ]
            )
        )
    }
}
