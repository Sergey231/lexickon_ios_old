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
    
    // MARK: Input
    @Published var email = ""
    @Published var password = ""
    @Published var submit: Void = ()
    
    // MARK: Output
    @Published var keyboardHeight: CGFloat = 0
    @Published var emailValidation: ValidationResult = ValidationResult.valid
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
    }
}
