//
//  HomeViewController.swift
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

final class HomeViewController: UIViewController {
    
    private let presenter: HomePresenter
    
    init(
        presenter: HomePresenter
    ) {
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

extension HomeViewController: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<HomeViewController>) -> UIView {
        return HomeViewController(
            presenter: HomePresenter()
        ).view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        HomeViewController(
            presenter: HomePresenter()
        )
    }
}
