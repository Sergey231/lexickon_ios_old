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
import UIExtensions
import RxExtensions
import Resolver

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
    
    private let scrollView = UIScrollView()
    private let nameTextField = LXTextField()
    private let emailLabel = UILabel()
    private let vocabularyView = VocabularyView()
    private let notificationSettingsView = NotificationsView()
    private let buttonsSetView = ProfileButtonsSetView()
    
    private let backButton = UIButton()
    
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
        return .darkContent
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
    
    //MARK: Create UI
    
    private func createUI() {

        scrollView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        backButton.setup {
            $0.setImage(Images.backArrow.image, for: .normal)
            $0.tintColor = .gray
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.size.equalTo(56)
                $0.left.equalToSuperview()
            }
        }
        
        profileIconView.setup {
            $0.backgroundColor = .gray
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.profileIconSize)
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(UIConstants.profileIconTopMargin)
            }
        }
        
        nameTextField.setup {
            scrollView.addSubview($0)
            $0.textField.font = .regular24
            $0.textField.textColor = Colors.baseText.color
            $0.textField.tintColor = Colors.mainBG.color
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(profileIconView.snp.bottom).offset(Margin.regular)
                $0.size.equalTo(Size.textField)
            }
        }
        
        emailLabel.setup {
            $0.font = .regular14
            $0.textAlignment = .center
            $0.textColor = Colors.paleText.color
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(nameTextField.snp.bottom)
                $0.height.equalTo(Size.textField.height)
            }
        }
        
        vocabularyView.setup {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(emailLabel.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.width.equalTo(view.snp.width)
            }
        }
        
        notificationSettingsView.setup {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(vocabularyView.snp.bottom)
                $0.left.right.equalToSuperview()
            }
        }
        
        buttonsSetView.setup {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(notificationSettingsView.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    //MARK: Configure UI
    
    private func configureUI() {
        
        configureHidingKeyboardByTap()
        
        let isEditModeRelay = BehaviorRelay<Bool>(value: false)
        
        let profileIconViewOutput = profileIconView.configure(
            input: ProfileIconView.Input(isEditMode: isEditModeRelay.asDriver())
        )
        
        let buttonsSetOutput = buttonsSetView.configure(input: ProfileButtonsSetView.Input())
        
        _ = buttonsSetOutput.msgToDeveloperDidTap.debug("🧢1").emit()
        _ = buttonsSetOutput.showIntroDidTap.debug("🧢2").emit()
        _ = buttonsSetOutput.supportLesickonDidTap.debug("🧢3").emit()
        
        let presenterOutput = presenter.configure(
            input: .init(
                didTapProfileIcon: profileIconViewOutput.didTap,
                isFocusedNameTextField: nameTextField.textField.rx.isFocused,
                didTapLogOut: buttonsSetOutput.logoutDidTap
            )
        )
        
        let vocabularyViewOutput = vocabularyView.configure(
            input: presenterOutput.vocabularyViewInput
        )
        
        _ = vocabularyViewOutput.autoaddingWordsDidTap.debug("🧵").emit()
        
        let notificationSettingsViewOutput = notificationSettingsView.configure(
            input: NotificationsView.Input()
        )
        
        _ = notificationSettingsViewOutput.fireWordsNotificationsDidTap.debug("🛹1").drive()
        _ = notificationSettingsViewOutput.readyWordsNotificationsDidTap.debug("🛹2").drive()
        _ = notificationSettingsViewOutput.timeInExercisesNotitidationsDidTap.debug("🛹3").drive()
        
        presenterOutput.isEditMode
            .drive(isEditModeRelay)
            .disposed(by: disposeBag)
        
        presenterOutput.isEditMode
            .drive(onNext: { [unowned self] isEditMode in
                if isEditMode {
                    self.nameTextField.textField.becomeFirstResponder()
                } else {
                    self.nameTextField.textField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        nameTextField.configure(
            input:
                LXTextField.Input(
                    placeholder: Str.profileNameTextFieldPlaceholder,
                    keyboardType: .asciiCapable,
                    returnKeyType: .done,
                    lineColor: Colors.mainBG.color,
                    lineIsVisibleBySelectedTextField: true
                )
        )
        
        presenterOutput.name
            .drive(nameTextField.textField.rx.text)
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
