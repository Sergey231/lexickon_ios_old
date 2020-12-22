
import UIKit
import Swinject
import Combine
import SnapKit
import RxCombine
import UIExtensions
import TimelaneCombine
import CombineCocoa
import RxFlow
import RxRelay
import RxSwift
import RxCocoa
import RxExtensions

final class RegistrationViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let presenter: RegistrationPresenter
    
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    
    private let logo: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.textLogo.image)
        imageView.contentMode = .scaleAspectFit
        imageView.setShadow()
        return imageView
    }()
    
    private let nameTextField: LXTextField = {
        let textField = LXTextField()
        textField.textField.enablesReturnKeyAutomatically = true
        textField.textField.becomeFirstResponder()
        return textField
    }()
    
    private let emailTextField = LXTextField()
    private let passwordTextField = LXTextField()
    
    private let msgLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let registrateButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.registrationSubmitButtonTitle, for: .normal)
        return button
    }()
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀 RegistrationViewController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.mainBG.color
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
        view.addSubviews(
            contentView,
            registrateButton
        )
        
        contentView.addSubviews(
            logo,
            nameTextField,
            emailTextField,
            passwordTextField,
            msgLabel
        )
        
        contentView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        logo.snp.makeConstraints {
            $0.size.equalTo(UIScreen.main.bounds.height/3)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(view.frame.size.height * -0.1)
        }
        
        nameTextField.snp.makeConstraints {
            $0.size.equalTo(Sizes.textField)
            $0.left.equalToSuperview().offset(Margin.mid)
            $0.right.equalToSuperview().offset(-Margin.mid)
            $0.centerY.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.size.equalTo(Sizes.textField)
            $0.left.equalToSuperview().offset(Margin.mid)
            $0.right.equalToSuperview().offset(-Margin.mid)
            $0.top.equalTo(nameTextField.snp.bottom).offset(Margin.regular)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(Sizes.textField.height)
            $0.left.equalToSuperview().offset(Margin.mid)
            $0.right.equalToSuperview().offset(-Margin.mid)
            $0.top.equalTo(emailTextField.snp.bottom).offset(Margin.regular)
        }
        
        registrateButton.snp.makeConstraints {
            $0.size.equalTo(Sizes.button)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Margin.regular)
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
        title = L10n.registrationCreateAccountTitle
        
        nameTextField.configure(input: LXTextField.Input(
            placeholder: L10n.registrationNameTextfield,
            leftIcon: Asset.Images.accountIcon.image,
            returnKeyType: .next
        ))
        
        emailTextField.configure(input: LXTextField.Input(
            placeholder: L10n.registrationEmailTextfield,
            leftIcon: Asset.Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next
        ))
        
        passwordTextField.configure(input: LXTextField.Input(
            placeholder: L10n.registrationPasswordTextfield,
            leftIcon: Asset.Images.lockIcon.image,
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
        
        presenterOutput.keyboardHeight
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
                    buttonTitle: L10n.errorAlertButtonTitle,
                    buttonColor: Asset.Colors.mainBG.color
                )
            }
            .subscribe(onNext: { _ in
                self.registrateButton.show()
                print("🌈🌈🌈")
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
        
        registrateButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
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
