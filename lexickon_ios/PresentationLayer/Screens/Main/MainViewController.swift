//
//  MainViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Swinject
import PinLayout
import Combine
import CombineCocoa

final class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let presenter: MainPresenter
    var onCompletion: CompletionBlock?
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension MainViewController: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<MainViewController>) -> UIView {
        return MainViewController(presenter: MainPresenter()).view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MainViewController_Preview: PreviewProvider {
    static var previews: some View {
        MainViewController(presenter: MainPresenter())
    }
}
