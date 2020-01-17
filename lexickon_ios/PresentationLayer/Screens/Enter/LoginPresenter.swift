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

final class LoginPersenter: PresenterType {
    
    // MARK: Input
    @Published var email = ""
    @Published var password = ""
    @Published var submit: Void = ()
    
    // MARK: Output
    @Published var emailValidation: ValidationResult = ValidationResult.valid
    @Published var canSubmit: Bool = false
}
