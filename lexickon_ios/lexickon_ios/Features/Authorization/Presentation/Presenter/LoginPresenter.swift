//
//  LoginPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import Validator
import LexickonApi
import RxCocoa
import RxSwift
import RxCombine

final class LoginPresenter: PresenterType {
    
    private let authorisationInteractor: AuthorizationInteractorProtocol
    
    init(authorisationInteractor: AuthorizationInteractorProtocol) {
        self.authorisationInteractor = authorisationInteractor
    }
    
    struct Input {
        let email: Driver<String?>
        let password: Driver<String?>
        let submit: Signal<Void>
    }
    
    struct Output {
        let keyboardHeight: Driver<CGFloat>
        let emailValidation: Driver<ValidationResult>
        let passwordValidation: Driver<ValidationResult>
        let canSubmit: Driver<Bool>
        let showLoading: Driver<Bool>
        let errorMsg: Signal<String>
        let disposables: CompositeDisposable
    }
    
    func configure(input: Input) -> Output {
        
        let errorMsg = PublishRelay<String>()
        let showLoading = BehaviorRelay<Bool>(value: false)
        
        let notificationCenter = NotificationCenter.default
        
        let keyboardShow = notificationCenter
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .asObservable()
            .map ({ notification -> CGFloat in
                guard
                    let info = notification.userInfo,
                    let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    else { return 0 }

                return keyboardFrame.height
            })
            .asDriver(onErrorJustReturn: 0)
        
        let keyboardHide = notificationCenter
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
            .asObservable()
            .asDriver(onErrorJustReturn: 0)
        
        let keyboard = Driver.merge(
            keyboardHide,
            keyboardShow
        )
        
        let emailValidation: Driver<ValidationResult> = {
            
            let nameMinRule = ValidationRuleLength(
                min: 2,
                error: TextFieldError.Email.incorrectEmail
            )
            
            return input.email.distinctUntilChanged()
                .map { ($0?.validate(rule: nameMinRule) ?? .valid) }
        }()
        
        let passwordValidation: Driver<ValidationResult> = {
            
            let minLengthRule = ValidationRuleLength(
                min: 5,
                error: TextFieldError.Password.tooShort
            )
            
            let maxLengthRule = ValidationRuleLength(
                max: 18,
                error: TextFieldError.Password.tooLong
            )
            
            var passwordValidationRules = ValidationRuleSet<String>()
            passwordValidationRules.add(rule: minLengthRule)
            passwordValidationRules.add(rule: maxLengthRule)
            
            return input.password.distinctUntilChanged()
                .map { $0?.validate(rules: passwordValidationRules) ?? .valid }
        }()
        
        let canSubmict = Driver.combineLatest(
            emailValidation,
            passwordValidation
        )
            .map { $0.isValid && $1.isValid }
        
        let logintAndPass = Driver.combineLatest(
            input.email,
            input.password
        ) { (login: $0, password: $1) }
        
        let loginDisposable = input.submit
            .asObservable()
            .withLatestFrom(logintAndPass)
            .flatMapLatest ({ arg -> Observable<Void> in
                showLoading.accept(true)
                guard
                    let login = arg.login,
                    let password = arg.password
                else {
                    return .empty()
                }
                return self.authorisationInteractor.login(
                    login: login,
                    password: password
                )
                    .asObservable()
            })
            .subscribe(
                onNext: { _ in showLoading.accept(false)
            }, onError: { error in
                errorMsg.accept(error.localizedDescription)
                showLoading.accept(false)
            })

        
        return Output(
            keyboardHeight: keyboard,
            emailValidation: emailValidation,
            passwordValidation: passwordValidation,
            canSubmit: canSubmict,
            showLoading: showLoading.asDriver(),
            errorMsg: errorMsg.asSignal(),
            disposables: CompositeDisposable(disposables: [loginDisposable])
        )
    }
}
