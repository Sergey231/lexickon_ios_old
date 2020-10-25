//
//  HomeViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject
import PinLayout
import Combine
import CombineCocoa
import RxFlow
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let profileIconView = ProfileIconView()
    
    private let disposeBag = DisposeBag()
    
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
        view.backgroundColor = .green
        
        createUI()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileIconView.pin
            .size(44)
            .right(16)
            .top(view.pin.safeArea.top)
    }
    
    private func configureUI() {
        profileIconView.backgroundColor = .gray
        profileIconView.configure(input: ProfileIconView.Input())
            .didTap
            .map { _ in MainStep.profile }
            .emit(to: steps)
            .disposed(by: disposeBag)
    }
    
    private func createUI() {
        view.addSubview(profileIconView)
    }
}
