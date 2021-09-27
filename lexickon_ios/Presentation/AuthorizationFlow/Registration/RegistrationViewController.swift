
import UIKit
import SnapKit
// import LXUIKit
import UIExtensions
import RxExtensions
import RxFlow
import RxSwift
import RxCocoa
import Resolver
import Assets

final class RegistrationViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: RegistrationPresenter
    
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Images.textLogo.image)
    private let nameTextField = LXTextField()
    private let emailTextField = LXTextField()
    private let passwordTextField = LXTextField()
    private let msgLabel = UILabel()
    
    private let registrateButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBG.color
        createUI()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func createUI() {
        
        contentView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.right.left.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        logo.setup {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .white
            $0.setShadow()
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIScreen.main.bounds.height/3)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(view.frame.size.height * -0.1)
            }
        }
        
        nameTextField.setup {
            $0.textField.enablesReturnKeyAutomatically = true
            $0.textField.becomeFirstResponder()
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(Size.textField.height)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.centerY.equalToSuperview().offset(40)
            }
        }
        
        msgLabel.setup {
            $0.textAlignment = .center
            $0.textColor = .white
            $0.numberOfLines = 2
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.height.equalTo(44)
                $0.bottom.equalTo(nameTextField.snp.top)
            }
        }
        
        emailTextField.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(Size.textField.height)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.top.equalTo(nameTextField.snp.bottom).offset(Margin.regular)
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
        
        registrateButton.setup {
            $0.setTitle(Str.registrationSubmitButtonTitle, for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(Size.button)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Margin.regular)
            }
        }
    }
    
    private func layout(bottom: CGFloat) {
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
    
    private func configureUI() {
        
        view.layoutIfNeeded()
        
        configureHidingKeyboardByTap()
        title = Str.registrationCreateAccountTitle
        
        nameTextField.configure(input: LXTextField.Input(
            placeholder: Str.registrationNameTextfield,
            leftIcon: Images.accountIcon.image,
            returnKeyType: .next
        ))
        
        emailTextField.configure(input: LXTextField.Input(
            placeholder: Str.registrationEmailTextfield,
            leftIcon: Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next
        ))
        
        passwordTextField.configure(input: LXTextField.Input(
            placeholder: Str.registrationPasswordTextfield,
            leftIcon: Images.lockIcon.image,
            isSecure: true,
            returnKeyType: .join
        ))
        
        let submit = Signal.merge(
            passwordTextField.textField.rx.controlEvent(.editingDidEndOnExit).asSignal(),
            registrateButton.rx.tap.asSignal()
        )
        
        let input = RegistrationPresenter.Input(
            name: nameTextField.rx.sbmitText,
            email: emailTextField.rx.sbmitText,
            password: passwordTextField.rx.sbmitText,
            passwordAgain: passwordTextField.rx.sbmitText,
            submit: submit
        )
        
        let presenterOutput = presenter.configure(input: input)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.layout(bottom: height)
            })
            .disposed(by: disposeBag)
        
        presenterOutput.nameIsNotValid
            .skip(1)
            .emit(to: nameTextField.rx.shake)
            .disposed(by: disposeBag)

        presenterOutput.emailIsNotValid
            .emit(to: emailTextField.rx.shake)
            .disposed(by: disposeBag)

        presenterOutput.passwordIsNotValid
            .emit(to: passwordTextField.rx.shake)
            .disposed(by: disposeBag)
        
        presenterOutput.canSubmit
            .asDriver()
            .drive(registrateButton.rx.valid)
            .disposed(by: disposeBag)
        
        presenterOutput.errorMsg
            .asObservable()
            .do(onNext: { _ in self.registrateButton.hide() })
            .flatMapLatest {
                return self.showMsg(
                    msg: $0,
                    buttonTitle: Str.errorAlertButtonTitle,
                    buttonColor: Colors.mainBG.color
                )
            }
            .subscribe(onNext: { _ in
                self.registrateButton.show()
            })
            .disposed(by: disposeBag)
        
        let textFields = [
            nameTextField,
            emailTextField,
            passwordTextField
        ]
        
        let enumerableTextFieldDisposables = EnumerableTextFieldHelper()
            .configureEnumerable(
                textFields: textFields,
                canSubmit: presenterOutput.canSubmit.asObservable()
            )
        
        CompositeDisposable(disposables: enumerableTextFieldDisposables)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .asDriver()
            .flatMap { _ in presenterOutput.msg }
            .drive(msgLabel.rx.textWithAnimaiton)
            .disposed(by: disposeBag)
        
        registrateButton.configureRoundedFilledStyle(titleColor: Colors.mainBG.color)
        registrateButton.configureTapScaleAnimation()
            .disposed(by: disposeBag)
        
        presenterOutput.registrated
            .asObservable()
            .map { _ in AuthorizationStep.begin(animated: true) }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            return false
        }
        return true
    }
}
