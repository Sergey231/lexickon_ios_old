//
//  LoginPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Combine
import SwiftUI
import Validator

final class LoginPresenter: PresenterType {
    
    struct Input {
        let email: AnyPublisher<String?, Never>
        let password: AnyPublisher<String?, Never>
        let submit: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let keyboardHeight: AnyPublisher<CGFloat, Never>
        let emailValidation: AnyPublisher<ValidationResult, Never>
        let passwordValidation: AnyPublisher<ValidationResult, Never>
        let canSubmit: AnyPublisher<Bool, Never>
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func configure(input: Input) -> Output {
        
        let notificationCenter = NotificationCenter.default
        
        let keyboardShowPublisher = notificationCenter
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                guard
                    let info = notification.userInfo,
                    let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    else { return 0 }

                return keyboardFrame.height
            }
        
        let keyboardHidePublisher = notificationCenter
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
        
        let keyboardPublisher = Publishers.Merge(
            keyboardHidePublisher,
            keyboardShowPublisher
        )
            .eraseToAnyPublisher()
        
        let emailValidationPublisher: AnyPublisher<ValidationResult, Never> = {
            
            let nameMinRule = ValidationRuleLength(
                min: 2,
                error: LXError.incorrectName
            )
            
            return input.email.removeDuplicates()
                .map { input in
                    input?.validate(rule: nameMinRule) ?? .invalid([LXError.incorrectEmail])
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
            
            var passwordValidationRules = ValidationRuleSet<String>()
            passwordValidationRules.add(rule: minLengthRule)
            passwordValidationRules.add(rule: maxLengthRule)
            
            return input.password.removeDuplicates()
                .map { password in
                    password?.validate(rules: passwordValidationRules)
                        ?? .invalid([LXError.Password.tooShort])
            }
            .eraseToAnyPublisher()
        }()
        
        let canSubmict = Publishers.CombineLatest(
            emailValidationPublisher,
            passwordValidationPublisher
        )
            .map { $0.isValid && $1.isValid }
            .eraseToAnyPublisher()
        
        return Output(
            keyboardHeight: keyboardPublisher,
            emailValidation: emailValidationPublisher,
            passwordValidation: passwordValidationPublisher,
            canSubmit: canSubmict
        )
    }
}
