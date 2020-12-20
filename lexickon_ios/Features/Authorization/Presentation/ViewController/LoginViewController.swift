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
import SnapKit
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
    
    private let contentView = UIView()
    private let logo: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.textLogo.image)
        imageView.contentMode = .scaleAspectFit
        imageView.setShadow()
        return imageView
    }()
    private let emailTextField = LXTextField()
    private let passwordTextField = LXTextField()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        return indicator
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.loginLoginButtonTitle, for: .normal)
        return button
    }()
    
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
        
        title = L10n.loginScreenTitle
        configureHidingKeyboardByTap()
        
        emailTextField.configure(input: LXTextField.Input(
            placeholder: L10n.registrationEmailTextfield,
            leftIcon: Asset.Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next,
            initValue: "sergey.borovikov@list.ru"
        ))
        
        passwordTextField.configure(input: LXTextField.Input(
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
            .do(onNext: { _ in self.loginButton.hide() })
            .flatMapLatest {
                return self.showMsg(
                    msg: $0,
                    buttonTitle: L10n.errorAlertButtonTitle,
                    buttonColor: Asset.Colors.mainBG.color
                )
            }
            .subscribe(onNext: { _ in
                self.loginButton.show()
                print("🌈🌈🌈")
            })
            .disposed(by: disposeBag)
        
        presenterOutput.keyboardHeight
            .drive(onNext: { [weak self] in
                self?.layout(bottom: $0)
            })
            .disposed(by: disposeBag)

        presenterOutput.logined
            .map { _ in AuthorizationStep.begin(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        let enumerableTextFieldDisposables = EnumerableTextFieldHelper()
            .configureEnumerable(textFields: [
                emailTextField,
                passwordTextField
            ])
            
        CompositeDisposable(disposables: enumerableTextFieldDisposables)
            .disposed(by: disposeBag)
        
        loginButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
        
        loginButton.configureTapScaleAnimation()
            .disposed(by: disposeBag)
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
        
        contentView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        logo.snp.makeConstraints {
            $0.size.equalTo(UIScreen.main.bounds.height/3)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(view.frame.size.height * -0.12)
        }
        
        emailTextField.snp.makeConstraints {
            $0.size.equalTo(Sizes.textField)
            $0.left.equalToSuperview().offset(Margin.mid)
            $0.right.equalToSuperview().offset(-Margin.mid)
            $0.centerY.equalToSuperview().offset(Margin.mid)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(Sizes.textField.height)
            $0.left.equalToSuperview().offset(Margin.mid)
            $0.right.equalToSuperview().offset(-Margin.mid)
            $0.top.equalTo(emailTextField.snp.bottom).offset(Margin.regular)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.height.equalTo(Sizes.textField.height)
            $0.width.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Margin.regular)
        }
        
        loginButton.snp.makeConstraints {
            $0.size.equalTo(Sizes.button)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom).offset(Margin.regular)
        }
    }
    
    fileprivate func layout(bottom: CGFloat) {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-bottom)
        }
        let logoSize = UIScreen.main.bounds.height - bottom
        logo.snp.updateConstraints {
            $0.size.equalTo(logoSize/3)
        }
        logo.superview?.layoutIfNeeded()
        contentView.superview?.layoutIfNeeded()
    }
}

//// MARK: - Reset DI Container
extension LoginViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        DI.shr.appContainer.resetObjectScope(ObjectScope.loginObjectScope)
    }
}
