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
    
    let steps = PublishRelay<Step>()
    
    private let presenter: ProfileMainScreenPresenter
    
    private let disposeBag = DisposeBag()
    
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
        
        presentOutput.didLogout.debug("⚽️")
            .map { _ in ProfileStep.logout }
            .emit(to: steps )
            .disposed(by: disposeBag)
    }
    
    private func createUI() {
        view.addSubview(logoutButton)
    }
}
