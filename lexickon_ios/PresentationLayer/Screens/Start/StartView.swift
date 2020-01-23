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

final class StartViewController: UIViewController {
    
    private let presenter: StartPresenter
    private var beginButton = UIButton()
    
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
        navigationController?.navigationBar.isHidden = true
        createUI()
        configureUI()
    }
    
    private func configureUI() {
        beginButton.setTitle(Localized.startBeginButtonTitle, for: .normal)
    }
    
    private func createUI() {
        view.addSubview(beginButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        beginButton.pin
            .vCenter()
            .horizontally(16)
            .height(44)
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
