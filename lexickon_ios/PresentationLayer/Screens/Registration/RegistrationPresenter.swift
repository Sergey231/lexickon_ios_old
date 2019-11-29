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

final class RegistrationPresenter: PresenterType {
    
    // MARK: Input
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    @Published var submit: Void = ()
    
    // MARK: Output
    @Published var keyboardHeight: CGFloat = 0
    @Published var nameValidation: ValidationResult = ValidationResult.valid
    @Published var emailValidation: ValidationResult = ValidationResult.valid
    @Published var passwordValidation: ValidationResult = ValidationResult.valid
    @Published var canSubmit: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.publisher(for: UIWindow.keyboardWillShowNotification)
            .map {
                guard
                    let info = $0.userInfo,
                    let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    else { return 0 }

                return keyboardFrame.height
            }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)
        
        notificationCenter.publisher(for: UIWindow.keyboardWillHideNotification)
            .map { _ in 0 }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)
        
        isUsernameValidPublisher
            .assign(to: \.nameValidation, on: self)
            .store(in: &cancellableSet)
        
        isEmailValidPublisher
            .assign(to: \.emailValidation, on: self)
            .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .assign(to: \.passwordValidation, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest3(
            isUsernameValidPublisher,
            isEmailValidPublisher,
            isPasswordValidPublisher)
            .map { $0.isValid && $1.isValid && $2.isValid }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellableSet)
    }
    
    private lazy var isUsernameValidPublisher: AnyPublisher<ValidationResult, Never> = {
        
        let nameMinRule = ValidationRuleLength(
            min: 2,
            error: LXError.incorrectName
        )
        
        return $name.removeDuplicates()
            .map { input in
                input.validate(rule: nameMinRule)
        }
        .eraseToAnyPublisher()
    }()
    
    private lazy var isEmailValidPublisher: AnyPublisher<ValidationResult, Never> = {
        
        let emailRule = ValidationRulePattern(
            pattern: EmailValidationPattern.standard,
            error: LXError.incorrectEmail)
        
        return $email.removeDuplicates()
            .map { input in
                input.validate(rule: emailRule)
        }
        .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordValidPublisher: AnyPublisher<ValidationResult, Never> = {
        
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
        passwordValidationRules.add(rule: lowcaseRule)
        passwordValidationRules.add(rule: upcaseRule)
        
        return $password.removeDuplicates()
            .map { password in
                password.validate(rules: passwordValidationRules)
        }
        .eraseToAnyPublisher()
    }()
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
