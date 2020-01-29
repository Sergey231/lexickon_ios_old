//
//  LoginView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Swinject
import Combine
import PinLayout

final class LoginViewController: UIViewController {

    var onCompletion : CompletionBlock?
    weak var coordinator: LoginCoordinator?
    private let presenter: LoginPresenter
    private let testLabel = UILabel()
    
    init(presenter: LoginPresenter) {
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
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.finishFlow(for: self)
    }
    
    private func configureUI() {
        testLabel.text = "Login"
        testLabel.textAlignment = .center
    }
    
    private func createUI() {
        view.addSubview(testLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        testLabel.pin
            .vCenter()
            .horizontally(16)
            .height(44)
    }
}


extension LoginViewController: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<LoginViewController>) -> UIView {
        return LoginViewController(presenter: LoginPresenter()).view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController(presenter: LoginPresenter())
    }
}
