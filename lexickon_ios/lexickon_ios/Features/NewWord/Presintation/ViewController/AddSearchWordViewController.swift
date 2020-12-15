//
//  AddSearchWordViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject
import SnapKit
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
    private var headerHeightConstraint: Constraint?
    fileprivate let presenter: AddSearchWordPresenter
    fileprivate var disposeBag = DisposeBag()
    
    // Public for Custom transitioning animator
    let headerView = AddWordHeaderView()
    let placeholderView = AddSearchPlaceholderView()
    
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
        self.placeholderView.stopFlaying()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func createUI() {
        view.addSubviews(
            headerView,
            placeholderView
        )
        
        headerView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            self.headerHeightConstraint = $0.height.greaterThanOrEqualTo(UIConstants.headerViewHeight).constraint
        }
        
        placeholderView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(140)
            $0.center.equalToSuperview()
        }
    }
    
    private func configureUI() {
        
        let headerViewOutput = headerView.configure()
            
        headerViewOutput.backButtonDidTap
            .map { NewWordStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        headerViewOutput.height.debug("😀")
            .drive(onNext: {
                self.view.layoutIfNeeded()
                if let height = self.headerHeightConstraint {
                    height.update(priority: $0)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}
