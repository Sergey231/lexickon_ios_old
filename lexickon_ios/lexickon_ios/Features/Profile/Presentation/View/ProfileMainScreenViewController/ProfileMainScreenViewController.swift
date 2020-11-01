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
import Swinject
import RxFlow
import PinLayout

class ProfileMainScreenViewController: UIViewController, Stepper {
    
    struct UIConstants {
        static let profileIconSize: CGFloat = 100
        static let profileIconTopMargin: CGFloat = 16
    }
    
    let steps = PublishRelay<Step>()
    
    private let presenter: ProfileMainScreenPresenter
    
    private let disposeBag = DisposeBag()
    
    let profileIconView = ProfileIconView()
    let backButton = UIButton()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backButton.pin
            .top(view.pin.safeArea.top)
            .left()
            .size(56)
        
        profileIconView.pin
            .size(UIConstants.profileIconSize)
            .hCenter()
            .top(view.pin.safeArea.top + UIConstants.profileIconTopMargin)
        
        logoutButton.pin
            .hCenter()
            .size(Sizes.button)
            .bottom(Margin.big)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        createUI()
        configureUI()
    }
    
    private func configureUI() {
        
        profileIconView.backgroundColor = .gray
        
        backButton.setImage(Asset.Images.backArrow.image, for: .normal)
        
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
    
    private func createUI() {
        view.addSubviews(
            backButton,
            logoutButton,
            profileIconView
        )
    }
}
