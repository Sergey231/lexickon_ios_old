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

final class StartViewController: UIViewController {
    
    weak var coordinator: StartCoordinator?
    private let presenter: StartPresenter
    var onCompletion : CompletionBlock?
    
    private let beginButton = UIButton()
    private let iAmHaveAccountButton = UIButton()
    private let createAccountButton = UIButton()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(presenter: StartPresenter) {
        self.presenter = presenter
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureUI() {
        
        beginButton.setTitle(Localized.startBeginButtonTitle, for: .normal)
        iAmHaveAccountButton.setTitle(Localized.startIHaveAccountButtonTitle, for: .normal)
        createAccountButton.setTitle(Localized.startCreateAccountButtonTitle, for: .normal)
        
        guard let coordinator = coordinator else { return }
        
        beginButton.tapPublisher.sink { _ in
            coordinator.main()
        }.store(in: &cancellableSet)
        
        iAmHaveAccountButton.tapPublisher.sink { _ in
            coordinator.login()
        }.store(in: &cancellableSet)
        
        createAccountButton.tapPublisher.sink { _ in
            coordinator.createAccount()
        }.store(in: &cancellableSet)
    }
    
    private func createUI() {
        view.addSubviews([
            beginButton,
            iAmHaveAccountButton,
            createAccountButton
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        beginButton.pin
            .vCenter()
            .horizontally(16)
            .height(44)
        
        iAmHaveAccountButton.pin
            .horizontally(16)
            .height(44)
            .below(of: beginButton)
            .marginTop(16)
        
        createAccountButton.pin
            .horizontally(16)
            .height(44)
            .below(of: iAmHaveAccountButton)
            .margin(16)
    }
}


extension StartViewController: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<StartViewController>) -> UIView {
        return StartViewController(presenter: StartPresenter()).view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct StartViewController_Preview: PreviewProvider {
    static var previews: some View {
        StartViewController(presenter: StartPresenter())
    }
}
