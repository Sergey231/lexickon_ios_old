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
        let msg: Driver<String>
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
            
            return input.name.debounce(.seconds(1))
                .map { name -> ValidationResult in
                    
                    guard let username = name else {
                        return .invalid([TextFieldError.Name.empty])
                    }
                    
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
            
            return input.email.debounce(.seconds(1))
                .map { email in
                    
                    guard let email = email else {
                        return .invalid([TextFieldError.Name.empty])
                    }
                    
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
            
            return input.password.debounce(.seconds(1))
                .map { password in
                    
                    guard let password = password else {
                        return .invalid([TextFieldError.Password.empty])
                    }
                    
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
            usernameValidation,
            emailValidation,
            passwordValidation
        ) { usernameValidation, emailValidation, passwordValidation -> String in
            if case let ValidationResult.invalid(validationErrors) = usernameValidation {
                return validationErrors.first?.message ?? ""
            } else if case let ValidationResult.invalid(validationErrors) = emailValidation {
                return validationErrors.first?.message ?? ""
            } else if case let ValidationResult.invalid(validationErrors) = passwordValidation {
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
