
import UIKit
import Swinject
import Combine
import PinLayout
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
    
    private var _bottom: CGFloat = 0
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Asset.Images.textLogo.image)
    private let nameTextField = TextField()
    private let emailTextField = TextField()
    private let passwordTextField = TextField()
    private let msgLabel = UILabel()
    private let submitButton = UIButton()
    
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
            submitButton
        )
        
        contentView.addSubviews(
            logo,
            nameTextField,
            emailTextField,
            passwordTextField,
            msgLabel
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    private func layout() {
        
        contentView.pin
            .top()
            .horizontally()
            .bottom(_bottom)
        
        logo.pin
            .size(contentView.frame.height/3)
            .hCenter()
            .vCenter(-12%)
        
        nameTextField.pin
            .height(Sizes.textField.height)
            .horizontally(Margin.mid)
            .vCenter()
            .marginTop(Margin.mid)
        
        emailTextField.pin
            .height(Sizes.textField.height)
            .horizontally(Margin.mid)
            .below(of: nameTextField)
            .marginTop(Margin.regular)
        
        passwordTextField.pin
            .height(Sizes.textField.height)
            .horizontally(Margin.mid)
            .below(of: emailTextField)
            .marginTop(Margin.regular)
        
        msgLabel.pin
            .height(Sizes.textField.height)
            .horizontally(Margin.mid)
            .below(of: passwordTextField)
            .marginTop(Margin.regular)
        
        submitButton.pin
            .hCenter()
            .size(Sizes.button)
            .bottom(Margin.big)
    }
    
    private func configureUI() {
        
        view.layoutIfNeeded()
        
        configureHidingKeyboardByTap()
        title = L10n.registrationCreateAccountTitle
        
        logo.contentMode = .scaleAspectFit
        logo.setShadow()
        
        nameTextField.textField.enablesReturnKeyAutomatically = true
        nameTextField.textField.becomeFirstResponder()
        
        nameTextField.configure(input: TextField.Input(
            placeholder: L10n.registrationNameTextfield,
            leftIcon: Asset.Images.accountIcon.image,
            returnKeyType: .next
        ))
        
        emailTextField.configure(input: TextField.Input(
            placeholder: L10n.registrationEmailTextfield,
            leftIcon: Asset.Images.emailIcon.image,
            keyboardType: .emailAddress,
            returnKeyType: .next
        ))
        
        passwordTextField.configure(input: TextField.Input(
            placeholder: L10n.registrationPasswordTextfield,
            leftIcon: Asset.Images.lockIcon.image,
            isSecure: true,
            returnKeyType: .join
        ))
        
        msgLabel.textAlignment = .center
        msgLabel.textColor = .white
        
        let submit = Signal.merge(
            passwordTextField.textField.rx.controlEvent(.editingDidEndOnExit).asSignal(),
            submitButton.rx.tap.asSignal()
        )
        
        let input = RegistrationPresenter.Input(
            name: nameTextField.textField.rx.text.asDriver(),
            email: emailTextField.textField.rx.text.asDriver(),
            password: passwordTextField.textField.rx.text.asDriver(),
            passwordAgain: passwordTextField.textField.rx.text.asDriver(),
            submit: submit
        )
        
        let presenterOutput = presenter.configure(input: input)
        
        presenterOutput.keyboardHeight
            .drive(onNext: { [weak self] height in
                self?._bottom = height
                self?.layout()
            })
            .disposed(by: disposeBag)
        
        presenterOutput.canSubmit
            .asDriver()
            .drive(submitButton.rx.valid)
            .disposed(by: disposeBag)
        
        let enumerableTextFieldDisposables = EnumerableTextFieldHelper()
            .configureEnumerable(textFields: [
                nameTextField,
                emailTextField,
                passwordTextField
            ])
        
        CompositeDisposable(disposables: enumerableTextFieldDisposables)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .asSignal()
            .flatMap { _ in presenterOutput.msg }
            .emit(to: msgLabel.rx.textWithAnimaiton)
            .disposed(by: disposeBag)
        
        submitButton.setTitle(L10n.registrationSubmitButtonTitle, for: .normal)
        submitButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
    }
}

// MARK: - Reset DI Container
extension RegistrationViewController {

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        DI.shr.appContainer.resetObjectScope(ObjectScope.registrationObjectScope)
    }
}
