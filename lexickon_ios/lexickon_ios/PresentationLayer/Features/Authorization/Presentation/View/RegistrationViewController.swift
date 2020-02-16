//
//  RgistrationPresenterView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Swinject
import Combine
import PinLayout
import XCoordinator
import RxCombine
import UIExtensions

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

final class RegistrationViewController: UIViewController {

    fileprivate let router: UnownedRouter<AuthorizationRoute>
    
    private let presenter: RegistrationPresenter
    
    private var cancellableSet = Set<AnyCancellable>()
    
    private var _bottom: CGFloat = 0
    
    private let contentView = UIView()
    private let logo = UIImageView(image: Asset.Images.textLogo.image)
    private let nameTextField = TextField()
    private let emailTextField = TextField()
    private let passwordTextField = TextField()
    
    init(
        presenter: RegistrationPresenter,
        router: UnownedRouter<AuthorizationRoute>
    ) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
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
        view.addSubview(contentView)
        contentView.addSubviews(
            logo,
            nameTextField,
            emailTextField,
            passwordTextField
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
    }
    
    private func configureUI() {
        
        view.layoutIfNeeded()
        
        configureHidingKeyboardByTap()
        navigationController?.setupLargeMainThemeNavBar()
        title = Localized.registrationCreateAccountTitle
        
        logo.contentMode = .scaleAspectFit
        logo.setShadow()
        
        nameTextField.configure(input: TextField.Input(
            placeholder: Localized.registrationNameTextfield,
            leftIcon: Asset.Images.accountIcon.image,
            returnKeyType: .next
        ))
        
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
                nameTextField,
                emailTextField,
                passwordTextField
            ])
    }
}

extension RegistrationViewController: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<RegistrationViewController>) -> UIView {
        return RegistrationViewController(
            presenter: RegistrationPresenter(),
            router: AuthorizationCoordinator(
                rootViewController: UINavigationController()
            ).unownedRouter
        ).view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct RegistrationView_Preview: PreviewProvider {
    static var previews: some View {
        RegistrationViewController(
            presenter: RegistrationPresenter(),
            router: AuthorizationCoordinator(
                rootViewController: UINavigationController()
            ).unownedRouter
        )
    }
}
