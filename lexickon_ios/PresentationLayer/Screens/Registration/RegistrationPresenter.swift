//
//  RegistrationPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Combine
import SwiftUI

final class RegistrationPresenter: PresenterType {
    
    // MARK: Input
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    @Published var submit: Void = ()
    
    // MARK: Output
    @Published var keyboardHeight: CGFloat = 0
    @Published var isValid = false
    
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
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
      $name
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { input in
          return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
      $password
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { password in
          return password == ""
        }
        .eraseToAnyPublisher()
    }
}
