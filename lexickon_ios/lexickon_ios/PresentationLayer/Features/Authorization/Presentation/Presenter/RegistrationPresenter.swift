//
//  RegistrationPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Combine
import SwiftUI
import Validator
import XCoordinator

final class RegistrationPresenter: PresenterType {
    
    struct Input {
        let name: AnyPublisher<String?, Never>
        let email: AnyPublisher<String?, Never>
        let password: AnyPublisher<String?, Never>
        let passwordAgain: AnyPublisher<String?, Never>
        let submit: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let keyboardHeight: AnyPublisher<CGFloat, Never>
        let nameValidation: AnyPublisher<ValidationResult, Never>
        let emailValidation: AnyPublisher<ValidationResult, Never>
        let passwordValidation: AnyPublisher<ValidationResult, Never>
        let canSubmit: AnyPublisher<Bool, Never>
    }
    
    private var router: UnownedRouter<AuthorizationRoute>?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func setRouter(router: UnownedRouter<AuthorizationRoute>) {
        self.router = router
    }
    
    func configure(input: Input) -> Output {
        
        let notificationCenter = NotificationCenter.default
        
        let usernameValidationPublisher: AnyPublisher<ValidationResult, Never> = {
            
            let nameMinRule = ValidationRuleLength(
                min: 2,
                error: LXError.incorrectName
            )
            
            return input.name.removeDuplicates()
                .map { input in
                    input?.validate(rule: nameMinRule) ?? .invalid([LXError.incorrectName])
                }
                .eraseToAnyPublisher()
        }()
        
        let emailValidationPublisher: AnyPublisher<ValidationResult, Never> = {
            
            let emailRule = ValidationRulePattern(
                pattern: EmailValidationPattern.standard,
                error: LXError.incorrectEmail)
            
            return input.email.removeDuplicates()
                .map { input in
                    input?.validate(rule: emailRule) ?? .invalid([LXError.incorrectEmail])
            }
            .eraseToAnyPublisher()
        }()
        
        let passwordValidationPublisher: AnyPublisher<ValidationResult, Never> = {
            
            let minLengthRule = ValidationRuleLength(
                min: 5,
                error: LXError.Password.tooShort
            )
            
            let maxLengthRule = ValidationRuleLength(
                max: 18,
                error: LXError.Password.tooLong
            )
            
            let digitRule = ValidationRulePattern(
                pattern: ContainsNumberValidationPattern(),
                error: LXError.Password.needDigital
            )
            
            let lowcaseRule = ValidationRulePattern(
                pattern: CaseValidationPattern.lowercase,
                error: LXError.Password.needLowcase
            )
            
            let upcaseRule = ValidationRulePattern(
                pattern: CaseValidationPattern.uppercase,
                error: LXError.Password.needUpcase
            )
            
            var passwordValidationRules = ValidationRuleSet<String>()
            passwordValidationRules.add(rule: digitRule)
            passwordValidationRules.add(rule: minLengthRule)
            passwordValidationRules.add(rule: maxLengthRule)
            passwordValidationRules.add(rule: lowcaseRule)
            passwordValidationRules.add(rule: upcaseRule)
            
            return input.password.removeDuplicates()
                .map { password in
                    password?.validate(rules: passwordValidationRules)
                        ?? .invalid([LXError.Password.tooShort])
            }
            .eraseToAnyPublisher()
        }()
        
        let keyboardShowPublisher = notificationCenter
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                guard
                    let info = notification.userInfo,
                    let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    else { return 0 }

                return keyboardFrame.height
            }
            .eraseToAnyPublisher()
        
        let keyboardHidePublisher = notificationCenter
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
        
        let keyboardHeight = Publishers.Merge(
            keyboardHidePublisher,
            keyboardShowPublisher
        )
            .eraseToAnyPublisher()
        
        let canSubmict = Publishers.CombineLatest3(
            usernameValidationPublisher,
            emailValidationPublisher,
            passwordValidationPublisher
        )
            .map { $0.isValid && $1.isValid && $2.isValid }
            .eraseToAnyPublisher()
        
        return Output(
            keyboardHeight: keyboardHeight,
            nameValidation: usernameValidationPublisher,
            emailValidation: emailValidationPublisher,
            passwordValidation: passwordValidationPublisher,
            canSubmit: canSubmict
        )
    }
}

// MARK: - Extract in future
enum LXError: ValidationError {
    
    enum Password: ValidationError {
        
        case needDigital
        case needUpcase
        case needLowcase
        case tooShort
        case tooLong
        
        var message: String {
            switch self {
            case .needDigital:
                return Localized.registrationPasswordMustContainDigits
            case .needUpcase:
                return Localized.registrationPasswordMustContainUpercaseCharacters
            case .needLowcase:
                return Localized.registrationPasswordMustContainLowercaseCharacters
            case .tooShort:
                return Localized.registrationPasswordTooShort
            case .tooLong:
                return Localized.registrationPasswordTooLong
            }
        }
    }
    
    case incorrectEmail
    case incorrectName
    
    var message: String {
        switch self {
        case .incorrectEmail:
            return Localized.registrationIncorrectEmail
        case .incorrectName:
            return Localized.registrationIncorrectName
        }
    }
}
