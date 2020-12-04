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
    
    let steps = PublishRelay<Step>()
    fileprivate let presenter: AddSearchWordPresenter
    fileprivate var disposeBag = DisposeBag()
    
    private let headerView = AddWordHeaderView()
    let backButton = UIButton()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backButton.pin
            .top(view.pin.safeArea.top)
            .left()
            .size(56)
        
        headerView.pin
            .horizontally()
            .height(140)
            .top()
    }
    
    private func createUI() {
        view.addSubviews(
            headerView,
            backButton
        )
    }
    
    private func configureUI() {
        backButton.setImage(Asset.Images.backArrow.image, for: .normal)
        backButton.rx.tap
            .asSignal()
            .map { NewWordStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
    }
}
