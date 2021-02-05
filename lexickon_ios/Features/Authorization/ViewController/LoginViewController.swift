//
//  LoginView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import UIComponents
import UIExtensions
import RxExtensions
import RxFlow
import RxSwift
import RxCocoa
import Resolver
import Assets

final class LoginViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: LoginPresenter
    
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Asset.Images.textLogo.image)
    private let emailTextField = LXTextField()
    private let passwordTextField = LXTextField()
    private let activityIndicator = UIActivityIndicatorView()
    private let loginButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("LoginViewController 💀")
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
    
    private func createUI() {
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logo.setup {
            $0.contentMode = .scaleAspectFit
            $0.setShadow()
            contentView.addSubview($0)
            logo.snp.makeConstraints {
                $0.size.equalTo(UIScreen.main.bounds.height/3)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(view.frame.size.height * -0.12)
            }
        }
        
        emailTextField.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(Size.textField.height)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.centerY.equalToSuperview().offset(Margin.mid)
            }
        }
        
        passwordTextField.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(Size.textField.height)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.top.equalTo(emailTextField.snp.bottom).offset(Margin.regular)
            }
        }
        
        activityIndicator.setup {
            $0.color = .white
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(Size.textField.height)
                $0.width.equalToSuperview()
                $0.top.equalTo(passwordTextField.snp.bottom).offset(Margin.regular)
            }
        }
        
        loginButton.setup {
            $0.setTitle(Str.loginLoginButtonTitle, for: .normal)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(Size.button)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(activityIndicator.snp.bottom).offset(Margin.regular)
            }
        }
    }
    
    private func configureUI() {
        
        title = Str.loginScreenTitle
        configureHidingKeyboardByTap()
        
        emailTextField.configure(input: LXTextField.Input(
            placeholder: Str.registrationEmailTextfield,
            leftIcon: Asset.Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next,
            initValue: "sergey.borovikov@list.ru"
        ))
        
        passwordTextField.configure(input: LXTextField.Input(
            placeholder: Str.registrationPasswordTextfield,
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
                    buttonTitle: Str.errorAlertButtonTitle,
                    buttonColor: Asset.Colors.mainBG.color
                )
            }
            .subscribe(onNext: { _ in
                self.loginButton.show()
                print("🌈")
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
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
