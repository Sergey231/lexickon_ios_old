//
//  LoginView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject
import Combine
import PinLayout
import UIExtensions
import CombineCocoa
import RxFlow
import RxRelay

final class LoginViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let presenter: LoginPresenter
    
    private var cancellableSet = Set<AnyCancellable>()
    
    private var _bottom: CGFloat = 0
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Asset.Images.textLogo.image)
    private let emailTextField = TextField()
    private let passwordTextField = TextField()
    private let activityIndicator = UIActivityIndicatorView()
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀 LoginViewController")
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
        activityIndicator.color = .white
        
        emailTextField.configure(input: TextField.Input(
            placeholder: L10n.registrationEmailTextfield,
            leftIcon: Asset.Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next
        ))
        
        passwordTextField.configure(input: TextField.Input(
            placeholder: L10n.registrationPasswordTextfield,
            leftIcon: Asset.Images.lockIcon.image,
            returnKeyType: .join
        ))
        
        let input = LoginPresenter.Input(
            email: emailTextField.textField.textPublisher,
            password: passwordTextField.textField.textPublisher,
            submit: passwordTextField.textField.returnPublisher
        )

        let presenterOutput = presenter.configure(input: input)

        presenterOutput.showLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                if $0 {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .store(in: &cancellableSet)
        
        presenterOutput.errorMsg
            .receive(on: DispatchQueue.main)
            .flatMap {
                self.alert(msgText: $0, bottonColor: Asset.Colors.mainBG.color)
            }
            .sink(receiveValue: { _ in
                print("🌈🌈🌈")
            })
            .store(in: &cancellableSet)
        
        presenterOutput.cancellables
            .forEach { $0.store(in: &cancellableSet) }
        
        presenterOutput.keyboardHeight
            .sink (receiveValue: { [weak self] in
                self?._bottom = $0
                self?.layout()
            })
            .store(in: &cancellableSet)

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
            passwordTextField,
            activityIndicator
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
        
        activityIndicator.pin
            .size(36)
            .below(of: passwordTextField)
            .marginTop(36)
            .hCenter()
    }
}

//// MARK: - Reset DI Container
extension LoginViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        DI.shr.appContainer.resetObjectScope(ObjectScope.loginObjectScope)
    }
}
