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
import UIComponents
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
    
    private let backButton = UIButton()
    private let logoutButton = UIButton()
    
    private let infoLabel = UILabel()
    
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
        view.backgroundColor = .red
        
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
        
        logoutButton.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.size.equalTo(Size.button)
                $0.bottom.equalToSuperview().offset(-Margin.big)
            }
        }
        
        infoLabel.setup {
            $0.text = "Profile is developing 😐"
            $0.textAlignment = .center
            $0.textColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func configureUI() {
        
        logoutButton.setTitle(
            Str.loginLoginButtonTitle,
            for: .normal
        )
        
        let didTapLogout = logoutButton.rx.tap
            .asSignal()
        
        let presentOutput = presenter.configure(
            input: .init(
                didTapLogOut: didTapLogout
            )
        )
        
        backButton.rx.tap
            .asSignal()
            .map { ProfileStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        presentOutput.didLogout
            .map { _ in ProfileStep.logout }
            .emit(to: steps )
            .disposed(by: disposeBag)
    }
}
