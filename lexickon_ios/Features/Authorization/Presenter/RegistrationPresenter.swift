//
//  RegistrationPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftUI
import Validator
import Resolver

final class RegistrationPresenter: PresenterType {
    
    @Injected var authorisationInteractor: AuthorizationInteractorProtocol

    struct Input {
        let name: Driver<String>
        let email: Driver<String>
        let password: Driver<String>
        let passwordAgain: Driver<String>
        let submit: Signal<Void>
    }
    
    struct Output {
        let keyboardHeight: Driver<CGFloat>
        let nameIsNotValid: Signal<Void>
        let emailIsNotValid: Signal<Void>
        let passwordIsNotValid: Signal<Void>
        let msg: Driver<String>
        let canSubmit: Driver<Bool>
        let showLoading: Driver<Bool>
        let errorMsg: Signal<String>
        let registrated: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func configure(input: Input) -> Output {
        
        let errorMsg = PublishRelay<String>()
        let showLoading = BehaviorRelay<Bool>(value: false)
        let nameIsNotValid = PublishRelay<Void>()
        let emailIsNotValid = PublishRelay<Void>()
        let passwordIsNotValid = PublishRelay<Void>()
        let notificationCenter = NotificationCenter.default
        
        let usernameValidation: Driver<ValidationResult> = {
            
            let nameMinRule = ValidationRuleLength(
                min: 2,
                error: TextFieldError.Name.tooShort
            )
            
            return input.name
                .debounce(.seconds(1))
                .map { username -> ValidationResult in

                    if username.isEmpty {
                        return .invalid([TextFieldError.Name.empty])
                    }
                        return username.validate(rule: nameMinRule)
                }
        }()
        
        let emailValidation: Driver<ValidationResult> = {
            
            let emailRule = ValidationRulePattern(
                pattern: EmailValidationPattern.standard,
                error: TextFieldError.Email.incorrectEmail)
            
            return input.email
                .debounce(.seconds(1))
                .map { email in

                    if email.isEmpty {
                        return .invalid([TextFieldError.Email.empty])
                    }
                    
                    return email.validate(rule: emailRule)
            }
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
            
            let digitRule = ValidationRulePattern(
                pattern: ContainsNumberValidationPattern(),
                error: TextFieldError.Password.needDigital
            )
            
            let lowcaseRule = ValidationRulePattern(
                pattern: CaseValidationPattern.lowercase,
                error: TextFieldError.Password.needLowcase
            )
            
            let upcaseRule = ValidationRulePattern(
                pattern: CaseValidationPattern.uppercase,
                error: TextFieldError.Password.needUpcase
            )
            
            var passwordValidationRules = ValidationRuleSet<String>()
            passwordValidationRules.add(rule: digitRule)
            passwordValidationRules.add(rule: minLengthRule)
            passwordValidationRules.add(rule: maxLengthRule)
            passwordValidationRules.add(rule: lowcaseRule)
            passwordValidationRules.add(rule: upcaseRule)
            
            return input.password
                .debounce(.seconds(2))
                .map { password in
                    
                    if password.isEmpty {
                        return .invalid([TextFieldError.Password.empty])
                    }
                    
                    return password.validate(rules: passwordValidationRules)
            }
        }()
        
        let keyboardShow = notificationCenter
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                guard
                    let info = notification.userInfo,
                    let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    else { return 0 }

                return keyboardFrame.height
            }
            .asObservable()
            .asDriver(onErrorJustReturn: 0)
        
        let keyboardHideDriver = notificationCenter
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
            .asObservable()
            .asDriver(onErrorJustReturn: 0)
        
        let keyboardHeight = Driver.merge(
            keyboardHideDriver,
            keyboardShow
        )
        
        let msg = Driver.combineLatest(
            usernameValidation.startWith(.invalid([TextFieldError.Name.empty])),
            emailValidation.startWith(.invalid([TextFieldError.Email.empty])),
            passwordValidation.startWith(.invalid([TextFieldError.Password.empty]))
        ) { usernameValidation, emailValidation, passwordValidation -> String in
            
            if case let ValidationResult.invalid(validationErrors) = usernameValidation {
                nameIsNotValid.accept(())
                return validationErrors.first?.message ?? ""
            } else if case let ValidationResult.invalid(validationErrors) = emailValidation {
                emailIsNotValid.accept(())
                return validationErrors.first?.message ?? ""
            } else if case let ValidationResult.invalid(validationErrors) = passwordValidation {
                passwordIsNotValid.accept(())
                return validationErrors.first?.message ?? ""
            }
            return ""
        }
        
        let canSubmict = Driver.combineLatest(
            usernameValidation,
            emailValidation,
            passwordValidation
        )
            .map { $0.isValid && $1.isValid && $2.isValid }
        
        let userCreateInfo = Driver.combineLatest(
            input.name,
            input.email,
            input.password
        ) { (name: $0, email: $1, password: $2) }
        
        let registrated = input.submit
            .asObservable()
            .withLatestFrom(userCreateInfo)
            .flatMapLatest ({ arg -> Signal<Void> in
                showLoading.accept(true)
                return self.authorisationInteractor.registrate(
                    name: arg.name,
                    email: arg.email,
                    password: arg.password
                )
                .asSignal { error -> Signal<()> in
                    errorMsg.accept(error.localizedDescription)
                    showLoading.accept(false)
                    return .empty()
                }
            })
            .withLatestFrom(userCreateInfo)
            .flatMapLatest ({ arg -> Signal<Void> in
                self.authorisationInteractor.login(
                    login: arg.email,
                    password: arg.password
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
            keyboardHeight: keyboardHeight,
            nameIsNotValid: nameIsNotValid.asSignal(),
            emailIsNotValid: emailIsNotValid.asSignal(),
            passwordIsNotValid: passwordIsNotValid.asSignal(),
            msg: msg,
            canSubmit: canSubmict,
            showLoading: showLoading.asDriver(),
            errorMsg: errorMsg.asSignal(),
            registrated: registrated
        )
    }
}

// MARK: - Extract in future
enum TextFieldError {
    
    enum Password: ValidationError {
        
        case empty
        case needDigital
        case needUpcase
        case needLowcase
        case tooShort
        case tooLong
        
        var message: String {
            switch self {
            case .empty:
                return L10n.registrationEnterPassword
            case .needDigital:
                return L10n.registrationPasswordMustContainDigits
            case .needUpcase:
                return L10n.registrationPasswordMustContainUpercaseCharacters
            case .needLowcase:
                return L10n.registrationPasswordMustContainLowercaseCharacters
            case .tooShort:
                return L10n.registrationPasswordTooShort
            case .tooLong:
                return L10n.registrationPasswordTooLong
            }
        }
    }
    
    enum Name: ValidationError {
        
        case empty
        case tooShort
        
        var message: String {
            switch self {
            case .empty:
                return L10n.registrationEnterName
            case .tooShort:
                return L10n.registrationNameTooShort
            }
        }
    }
    
    enum Email: ValidationError {
        
        case empty
        case incorrectEmail
        
        var message: String {
            switch self {
            case .empty:
                return L10n.registrationEnterEmail
            case .incorrectEmail:
                return L10n.registrationIncorrectEmail
            }
        }
    }
}
