//
//  ProfileMainScreen.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
// import LXUIKit

final class ProfileMainScreenPresenter {
    
    @Injected var logoutUseCase: LogoutUseCase
    
    @Injected var interactor: ProfileInteractorProtocol
    
    struct Input {
        let didTapProfileIcon: Signal<Void>
        let isFocusedNameTextField: Driver<Bool>
        let didTapLogOut: Signal<Void>
    }
    
    struct Output {
        let didLogout: Signal<Void>
        let name: Driver<String>
        let email: Driver<String>
        let isEditMode: Driver<Bool>
        let vocabularyViewInput: VocabularyView.Input
        let disposables: CompositeDisposable
    }
    
    func configure(input: Input) -> Output {
        
        let didLogout = input.didTapLogOut
            .flatMap { [unowned self] in
                self.logoutUseCase.configure().didLogout
                    .asSignal(onErrorSignalWith: .empty())
            }
        
        let name = interactor.user.name
            .asDriver(onErrorJustReturn: "")
        
        let email = interactor.user.email
            .asDriver(onErrorJustReturn: "")
        
        let isEditModeRelay = BehaviorRelay<Bool>(value: false)
        
        let didTapProfileIconDisposable = input.didTapProfileIcon
            .withLatestFrom(isEditModeRelay.asSignal(onErrorSignalWith: .empty()))
            .map(!)
            .emit(to: isEditModeRelay)
        
        let isFocusedNameTextFieldDisposable = input.isFocusedNameTextField
            .drive(isEditModeRelay)
        
        let disposables = CompositeDisposable(disposables: [
            didTapProfileIconDisposable,
            isFocusedNameTextFieldDisposable
        ])
        
        let vocabularyViewInput = VocabularyView.Input(
            newWordsCount: 5,
            oneDayWordsCount: 3,
            oneWeekWordsCount: 10,
            oneMonthWordsCount: 54,
            halfYearWordsCount: 36
        )
        
        return Output(
            didLogout: didLogout,
            name: name,
            email: email,
            isEditMode: isEditModeRelay.asDriver(),
            vocabularyViewInput: vocabularyViewInput,
            disposables: disposables
        )
    }
}
