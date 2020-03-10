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
import CombineCocoa

final class LoginViewController: UIViewController {
    
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
        presenter.setRouter(router)
        self.presenter = presenter
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
        
        let input = LoginPresenter.Input(
            email: emailTextField.textField.textPublisher,
            password: passwordTextField.textField.textPublisher,
            submit: passwordTextField.textField.returnPublisher
        )

        let presenterOutput = presenter.configure(input: input)

        presenterOutput.keyboardHeight.sink { [weak self] in
            self?._bottom = $0
            self?.layout()
        }.store(in: &cancellableSet)

        EnumerableTextFieldHelper()
            .configureEnumerable(textFields: [
                emailTextField,
                passwordTextField
            ])
            .forEach { $0.store(in: &cancellableSet) }
    }
    
    private func createUI() {
        
        view.addSubview(contentView)
        
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

// MARK: - Reset DI Container
extension LoginViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        DI.shr.appContainer.resetObjectScope(ObjectScope.loginObjectScope)
    }
}


extension LoginViewController: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<LoginViewController>) -> UIView {
        return LoginViewController(
            presenter: LoginPresenter(),
            router: AuthorizationCoordinator.empty()
        ).view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController(
            presenter: LoginPresenter(),
            router: AuthorizationCoordinator.empty()
        )
    }
}
