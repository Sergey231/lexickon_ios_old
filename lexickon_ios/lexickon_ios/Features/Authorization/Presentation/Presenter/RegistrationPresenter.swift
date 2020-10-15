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

final class RegistrationPresenter: PresenterType {
    
    struct Input {
        let name: Driver<String?>
        let email: Driver<String?>
        let password: Driver<String?>
        let passwordAgain: Driver<String?>
        let submit: Signal<Void>
    }
    
    struct Output {
        let keyboardHeight: Driver<CGFloat>
        let nameValidation: Driver<ValidationResult>
        let emailValidation: Driver<ValidationResult>
        let passwordValidation: Driver<ValidationResult>
        let msg: Signal<String>
        let canSubmit: Driver<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    func configure(input: Input) -> Output {
        
        let notificationCenter = NotificationCenter.default
        
        let usernameValidation: Driver<ValidationResult> = {
            
            let nameMinRule = ValidationRuleLength(
                min: 2,
                error: TextFieldError.Name.tooShort
            )
            
            return input.name.distinctUntilChanged()
                .compactMap { name -> ValidationResult in
                    
                    guard let username = name else {
                        return .invalid([TextFieldError.Name.empty])
                    }
                    
                    if username.isEmpty {
                        return .invalid([TextFieldError.Name.empty])
                    } else {
                        return username.validate(rule: nameMinRule)
                    }
                }
        }()
        
        let emailValidation: Driver<ValidationResult> = {
            
            let emailRule = ValidationRulePattern(
                pattern: EmailValidationPattern.standard,
                error: TextFieldError.Email.incorrectEmail)
            
            return input.email.distinctUntilChanged()
                .map { input in
                    input?.validate(rule: emailRule) ?? .invalid([TextFieldError.Email.incorrectEmail])
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
            
            return input.password.distinctUntilChanged()
                .map { password in
                    password?.validate(rules: passwordValidationRules)
                        ?? .invalid([TextFieldError.Password.tooShort])
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
        
        let usernameValidationMsg = usernameValidation
            .map { valid -> String in
                switch valid {
                case .valid:
                    return ""
                case .invalid(let validationErrors):
                    return validationErrors.first?.message ?? ""
                }
            }
            .asSignal(onErrorJustReturn: "")
        
        let msg = Signal.merge(usernameValidationMsg)
        
        let canSubmict = Driver.combineLatest(
            usernameValidation,
            emailValidation,
            passwordValidation
        )
            .map { $0.isValid && $1.isValid && $2.isValid }
            
        
        return Output(
            keyboardHeight: keyboardHeight,
            nameValidation: usernameValidation,
            emailValidation: emailValidation,
            passwordValidation: passwordValidation,
            msg: msg,
            canSubmit: canSubmict
        )
    }
}

// MARK: - Extract in future
enum TextFieldError {
    
    enum Password: ValidationError {
        
        case needDigital
        case needUpcase
        case needLowcase
        case tooShort
        case tooLong
        
        var message: String {
            switch self {
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
                return L10n.registraitonEnterName
            case .tooShort:
                return L10n.registraitonNameTooShort
            }
        }
    }
    
    enum Email: ValidationError {
        
        case incorrectEmail
        
        var message: String {
            switch self {
            case .incorrectEmail:
                return L10n.registrationIncorrectEmail
            }
        }
    }
}
