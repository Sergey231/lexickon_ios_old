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
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let presenter: LoginPresenter
    
    private let disposeBag = DisposeBag()
    
    private var _bottom: CGFloat = 0
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Asset.Images.textLogo.image)
    private let emailTextField = TextField()
    private let passwordTextField = TextField()
    private let activityIndicator = UIActivityIndicatorView()
    private let loginButton = UIButton()
    
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
        layout()
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
            returnKeyType: .next,
            initValue: "sergey.borovikov@list.ru"
        ))
        
        passwordTextField.configure(input: TextField.Input(
            placeholder: L10n.registrationPasswordTextfield,
            leftIcon: Asset.Images.lockIcon.image,
            isSecure: true,
            returnKeyType: .join,
            initValue: "Password"
        ))
        
        let submit = Signal.merge(
            passwordTextField.textField.rx.controlEvent(.editingDidEndOnExit).asSignal(),
            loginButton.rx.tap.asSignal()
        )
        
        let presenterInput = LoginPresenter.Input(
            email: emailTextField.textField.rx.text.asDriver(),
            password: passwordTextField.textField.rx.text.asDriver(),
            submit: submit
        )

        let presenterOutput = presenter.configure(input: presenterInput)

        presenterOutput.showLoading
            .drive(onNext: { [weak self] in
                if $0 {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        presenterOutput.errorMsg
            .asObservable()
            .flatMapLatest {
                self.showMsg(msg: $0)
            }
            .subscribe(onNext: { _ in
                print("🌈🌈🌈")
            })
            .disposed(by: disposeBag)
        
        presenterOutput.disposables
            .disposed(by: disposeBag)
        
        presenterOutput.keyboardHeight
            .drive(onNext: { [weak self] in
                self?._bottom = $0
                self?.layout()
            })
            .disposed(by: disposeBag)

        let enumerableTextFieldDisposables = EnumerableTextFieldHelper()
            .configureEnumerable(textFields: [
                emailTextField,
                passwordTextField
            ])
            
        CompositeDisposable(disposables: enumerableTextFieldDisposables)
            .disposed(by: disposeBag)
        
        loginButton.setTitle(L10n.loginLoginButtonTitle, for: .normal)
        loginButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
    }
    
    private func createUI() {
        
        view.addSubview(contentView)
        
        contentView.addSubviews(
            logo,
            emailTextField,
            passwordTextField,
            activityIndicator,
            loginButton
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
            .size(Sizes.activityIndicator)
            .below(of: passwordTextField)
            .marginTop(Margin.big)
            .hCenter()
        
        loginButton.pin
            .hCenter()
            .size(Sizes.button)
            .bottom(Margin.big)
    }
}

//// MARK: - Reset DI Container
extension LoginViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        DI.shr.appContainer.resetObjectScope(ObjectScope.loginObjectScope)
    }
}
