//
//  AddSearchWordViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
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
import UIExtensions
import RxDataSources

final class AddSearchWordViewController: UIViewController, Stepper, UIGestureRecognizerDelegate {
    
    struct UIConstants {
        static let headerViewHeight: CGFloat = 156
    }
    
    let steps = PublishRelay<Step>()
    fileprivate let presenter: AddSearchWordPresenter
    fileprivate var disposeBag = DisposeBag()
    
    // Public for Custom transitioning animator
    let headerView = AddWordHeaderView()
    let addSearchWordView = AddSearchPlaceholderView()
    
    init(
        presenter: AddSearchWordPresenter
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀 Home")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.addSearchWordView.stopFlaying()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.pin
            .horizontally()
            .height(UIConstants.headerViewHeight)
            .top()
        
        addSearchWordView.pin
            .width(200)
            .height(140)
            .center()
    }
    
    private func createUI() {
        view.addSubviews(
            headerView,
            addSearchWordView
        )
    }
    
    private func configureUI() {
        let headerViewOutput = headerView.configure()
            
        headerViewOutput.backButtonDidTap
            .map { NewWordStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
//        headerViewOutput.height
//            .drive(headerView.rx.height)
//            .disposed(by: disposeBag)
    }
}
