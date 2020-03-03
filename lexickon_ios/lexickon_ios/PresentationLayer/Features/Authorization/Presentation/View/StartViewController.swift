//
//  StartView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Swinject
import Combine
import PinLayout
import CombineCocoa
import XCoordinator

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

final class StartViewController: UIViewController {
    
    private let router: UnownedRouter<AuthorizationRoute>
    
    private let presenter: StartPresenter
    
    private let logo = StartLogo()
    private let beginButton = UIButton()
    private let iAmHaveAccountButton = UIButton()
    private let createAccountButton = UIButton()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(
        presenter: StartPresenter,
        router: UnownedRouter<AuthorizationRoute>
    ) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.mainBG.color
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        logo.startAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logo.stopAnimation()
    }
    
    private func configureUI() {
        
        navigationController?.setupLargeMainThemeNavBar()
        
        beginButton.setTitle(Localized.startBeginButtonTitle, for: .normal)
        beginButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
        iAmHaveAccountButton.setTitle(Localized.startIHaveAccountButtonTitle, for: .normal)
        iAmHaveAccountButton.setRoundedBorderedStyle(bgColor: Asset.Colors.mainBG.color)
        createAccountButton.setTitle(Localized.startCreateAccountButtonTitle, for: .normal)
        createAccountButton.setRoundedBorderedStyle(bgColor: Asset.Colors.mainBG.color)
        
        beginButton.tapPublisher.sink { _ in
            self.router.trigger(.begin)
        }.store(in: &cancellableSet)
        
        iAmHaveAccountButton.tapPublisher.sink { _ in
            self.router.trigger(.login)
        }.store(in: &cancellableSet)
        
        createAccountButton.tapPublisher.sink { _ in
            self.router.trigger(.registrate)
        }.store(in: &cancellableSet)
    }
    
    private func createUI() {
        view.addSubviews(
            logo,
            beginButton,
            iAmHaveAccountButton,
            createAccountButton
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logo.pin
            .center()
        
        createAccountButton.pin
            .hCenter()
            .size(Sizes.button)
            .bottom(Margin.huge)
        
        iAmHaveAccountButton.pin
            .hCenter()
            .size(Sizes.button)
            .above(of: createAccountButton)
            .marginBottom(Margin.mid)
        
        beginButton.pin
            .hCenter()
            .size(Sizes.button)
            .above(of: iAmHaveAccountButton)
            .marginBottom(Margin.mid)
    }
}


extension StartViewController: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<StartViewController>) -> UIView {
        return StartViewController(
            presenter: StartPresenter(),
            router: AuthorizationCoordinator(rootViewController: UINavigationController()).unownedRouter
        ).view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct StartViewController_Preview: PreviewProvider {
    static var previews: some View {
        StartViewController(
            presenter: StartPresenter(),
            router: AuthorizationCoordinator(rootViewController: UINavigationController()).unownedRouter
        )
    }
}
