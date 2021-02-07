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
import Resolver
import Assets

final class LoginPresenter {
    
    @Injected var authorisationInteractor: AuthorizationInteractorProtocol

    struct Input {
        let email: Driver<String?>
        let password: Driver<String?>
        let submit: Signal<Void>
    }
    
    struct Output {
        let emailValidation: Driver<ValidationResult>
        let passwordValidation: Driver<ValidationResult>
        let canSubmit: Driver<Bool>
        let showLoading: Driver<Bool>
        let errorMsg: Signal<String>
        let logined: Signal<Void>
    }
    
    // MARK: - Extract in future
    enum TextFieldError {
        
        enum Password: ValidationError {

            case tooShort
            case tooLong
            
            var message: String {
                switch self {
                case .tooShort:
                    return Str.registrationPasswordTooShort
                case .tooLong:
                    return Str.registrationPasswordTooLong
                }
            }
        }
        
        enum Email: ValidationError {
            
            case incorrectEmail
            
            var message: String {
                switch self {
                case .incorrectEmail:
                    return Str.registrationIncorrectEmail
                }
            }
        }
    }
    
    func configure(input: Input) -> Output {
        
        let errorMsg = PublishRelay<String>()
        let showLoading = BehaviorRelay<Bool>(value: false)
        
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
        
        let logined = input.submit
            .asObservable()
            .withLatestFrom(logintAndPass)
            .flatMapLatest ({ arg -> Signal<Void> in
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
                .asSignal { error -> Signal<()> in
                    errorMsg.accept(error.localizedDescription)
                    showLoading.accept(false)
                    return .empty()
                }
            })
            .do(onNext: { _ in showLoading.accept(false) })
            .asSignal(onErrorSignalWith: .empty())

        
        return Output(
            emailValidation: emailValidation,
            passwordValidation: passwordValidation,
            canSubmit: canSubmict,
            showLoading: showLoading.asDriver(),
            errorMsg: errorMsg.asSignal(),
            logined: logined
        )
    }
}
