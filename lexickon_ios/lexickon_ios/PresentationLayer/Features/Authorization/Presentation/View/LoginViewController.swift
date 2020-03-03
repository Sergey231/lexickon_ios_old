//
//  LoginView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Swinject
import Combine
import PinLayout
import XCoordinator
import UIExtensions

final class LoginViewController: UIViewController {

    private let router: UnownedRouter<AuthorizationRoute>
    
    private let presenter: LoginPresenter
    
    private var cancellableSet = Set<AnyCancellable>()
    
    private var _bottom: CGFloat = 0
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Asset.Images.textLogo.image)
    private let emailTextField = TextField()
    private let passwordTextField = TextField()
    
    init(
        presenter: LoginPresenter,
        router: UnownedRouter<AuthorizationRoute>
    ) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.mainBG.color
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func configureUI() {
        
        configureHidingKeyboardByTap()
        
        view.addSubview(contentView)
        
        logo.contentMode = .scaleAspectFit
        logo.setShadow()
        
        emailTextField.configure(input: TextField.Input(
            placeholder: Localized.registrationEmailTextfield,
            leftIcon: Asset.Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next
        ))
        
        passwordTextField.configure(input: TextField.Input(
            placeholder: Localized.registrationPasswordTextfield,
            leftIcon: Asset.Images.lockIcon.image,
            returnKeyType: .join
        ))
        
        presenter.$keyboardHeight.sink {
            self._bottom = $0
            self.layout()
        }.store(in: &cancellableSet)
        
        EnumerableTextFieldHelper(cancellableSet: cancellableSet)
            .configureEnumerable(textFields: [
                emailTextField,
                passwordTextField
            ])
    }
    
    private func createUI() {
        
        contentView.addSubviews(
            logo,
            emailTextField,
            passwordTextField
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        layout()
    }
    
    fileprivate func layout() {
        
        contentView.pin
            .top()
            .horizontally()
            .bottom(_bottom)
        
        logo.pin
            .size(contentView.frame.height/3)
            .hCenter()
            .vCenter(-12%)
        
        emailTextField.pin
            .height(Sizes.textField.height)
            .horizontally(Margin.mid)
            .vCenter()
            .marginTop(Margin.mid)
        
        passwordTextField.pin
            .height(Sizes.textField.height)
            .horizontally(Margin.mid)
            .below(of: emailTextField)
            .marginTop(Margin.regular)
    }
}


extension LoginViewController: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<LoginViewController>) -> UIView {
        return LoginViewController(
            presenter: LoginPresenter(),
            router: AuthorizationCoordinator(rootViewController: UINavigationController()).unownedRouter
        ).view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController(
            presenter: LoginPresenter(),
            router: AuthorizationCoordinator(rootViewController: UINavigationController()).unownedRouter
        )
    }
}
