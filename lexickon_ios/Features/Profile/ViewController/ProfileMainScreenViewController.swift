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

class ProfileMainScreenViewController: UIViewController, Stepper {
    
    struct UIConstants {
        static let profileIconSize: CGFloat = 100
        static let profileIconTopMargin: CGFloat = 16
    }
    
    let steps = PublishRelay<Step>()
    
    private let presenter: ProfileMainScreenPresenter
    
    private let disposeBag = DisposeBag()
    
    let profileIconView: ProfileIconView = {
        let iconView = ProfileIconView()
        iconView.backgroundColor = .gray
        return iconView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Images.backArrow.image, for: .normal)
        return button
    }()
    
    private let logoutButton = UIButton()
    
    init(presenter: ProfileMainScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("💀 ProfileMainScreen")
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
    
    private func createUI() {
        view.addSubviews(
            backButton,
            logoutButton,
            profileIconView
        )
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.size.equalTo(56)
            $0.left.equalToSuperview()
        }
        
        profileIconView.snp.makeConstraints {
            $0.size.equalTo(UIConstants.profileIconSize)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIConstants.profileIconTopMargin)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Sizes.button)
            $0.bottom.equalToSuperview().offset(-Margin.big)
        }
    }
    
    private func configureUI() {
        
        logoutButton.setTitle(
            L10n.loginLoginButtonTitle,
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
