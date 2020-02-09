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

final class RegistrationViewController: UIViewController {

    private let router: UnownedRouter<AppRoute>
    
    private let presenter: RegistrationPresenter
    private let testLabel = UILabel()
    
    init(
        presenter: RegistrationPresenter,
        router: UnownedRouter<AppRoute>
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        testLabel.pin
            .vCenter()
            .horizontally(16)
            .height(44)
    }
    
    private func configureUI() {
        testLabel.text = "Registration"
        testLabel.textAlignment = .center
    }
    
    private func createUI() {
        view.addSubview(testLabel)
    }
}


//extension RegistrationViewController: UIViewRepresentable {
//
//    func makeUIView(context: UIViewRepresentableContext<RegistrationViewController>) -> UIView {
//        return RegistrationViewController(presenter: RegistrationPresenter()).view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//struct RegistrationView_Preview: PreviewProvider {
//    static var previews: some View {
//        RegistrationViewController(presenter: RegistrationPresenter())
//    }
//}
