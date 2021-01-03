//
//  AddSearchWordViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import RxFlow
import RxCocoa
import RxSwift
import UIExtensions
import RxDataSources
import Resolver

final class AddSearchWordViewController: UIViewController, Stepper, UIGestureRecognizerDelegate {
    
    struct UIConstants {
        static let headerViewHeight: CGFloat = 156
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: AddSearchWordPresenter
    fileprivate var disposeBag = DisposeBag()
    
    // Public for Custom transitioning animator
    let headerView = AddWordHeaderView()
    let placeholderView = AddSearchPlaceholderView()
    
    init() {
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
    
    private func createUI() {
        view.addSubviews(
            headerView,
            placeholderView
        )
        
        headerView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(UIConstants.headerViewHeight)
        }
        
        placeholderView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(140)
            $0.center.equalToSuperview()
        }
    }
    
    private func configureUI() {
        
        let presenterOutput = presenter.configurate(input: .init(translate: .just("Hi")))
        
        let headerViewOutput = headerView.configure()
            
        headerViewOutput.backButtonDidTap
            .map { NewWordStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        headerViewOutput.height
            .drive(headerView.rx.height)
            .disposed(by: disposeBag)
        
        presenterOutput.translation.debug("🎲").emit()
    }
}

private extension Reactive where Base: AddWordHeaderView {
    var height: Binder<CGFloat> {
        return Binder(base) { base, height in
            UIView.animate(withDuration: 0.2) {
                base.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                base.superview?.layoutIfNeeded()
            }
        }
    }
}
