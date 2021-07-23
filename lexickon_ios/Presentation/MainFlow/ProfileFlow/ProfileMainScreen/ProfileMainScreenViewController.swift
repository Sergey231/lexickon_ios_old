//
//  ProfileMainScreenViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import SnapKit
import LXUIKit
import UIExtensions
import Resolver
import Assets

class ProfileMainScreenViewController: UIViewController, Stepper {
    
    struct UIConstants {
        static let profileIconSize: CGFloat = 100
        static let profileIconTopMargin: CGFloat = 16
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: ProfileMainScreenPresenter
    
    private let disposeBag = DisposeBag()
    
    // Public for Animator
    let profileIconView = ProfileIconView()
    
    private let nickNameTextField = LXTextField()
    private let emailLabel = UILabel()
    
    private let backButton = UIButton()
    private let logoutButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            steps.accept(ProfileStep.addWord)
        }
    }
    
    private func createUI() {

        backButton.setup {
            $0.setImage(Images.backArrow.image, for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.size.equalTo(56)
                $0.left.equalToSuperview()
            }
        }
        
        profileIconView.setup {
            $0.backgroundColor = .gray
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.profileIconSize)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIConstants.profileIconTopMargin)
            }
        }
        
        nickNameTextField.setup {
            view.addSubview($0)
            $0.textField.font = .regular24
            $0.textField.textColor = Colors.baseText.color
            $0.textField.tintColor = Colors.mainBG.color
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(profileIconView.snp.bottom).offset(Margin.regular)
                $0.size.equalTo(Size.textField)
            }
        }
        
        logoutButton.setup {
            view.addSubview($0)
            $0.setTitle(
                Str.loginLoginButtonTitle,
                for: .normal
            )
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.size.equalTo(Size.button)
                $0.bottom.equalToSuperview().offset(-Margin.big)
            }
        }
        
        emailLabel.setup {
            $0.font = .regular14
            $0.textAlignment = .center
            $0.textColor = Colors.paleText.color
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(nickNameTextField.snp.bottom)
                $0.height.equalTo(Size.textField.height)
            }
        }
    }
    
    private func configureUI() {
        
        configureHidingKeyboardByTap()
        
        logoutButton.setRoundedBorderedStyle(
            bgColor: .white,
            borderColor: Colors.mainBG.color,
            titleColor: Colors.mainBG.color
        )
        
        let didTapLogout = logoutButton.rx.tap
            .asSignal()
        
        let presenterOutput = presenter.configure(
            input: .init(
                didTapLogOut: didTapLogout
            )
        )
        
        nickNameTextField.configure(
            input:
                LXTextField.Input(
                    placeholder: "Ввидите публичное имя",
                    keyboardType: .asciiCapable,
                    returnKeyType: .done,
                    lineColor: Colors.mainBG.color,
                    lineIsVisibleBySelectedTextField: true
                )
        )
        
        presenterOutput.name
            .drive(nickNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        presenterOutput.email
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asSignal()
            .map { ProfileStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        presenterOutput.didLogout
            .map { _ in ProfileStep.logout }
            .emit(to: steps )
            .disposed(by: disposeBag)
    }
}
