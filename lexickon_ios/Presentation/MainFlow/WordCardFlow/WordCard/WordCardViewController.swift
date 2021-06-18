//
//  WordCardViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.06.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import RxSwift
import LXControlKit
import UIExtensions
import RxExtensions
import Resolver
import Assets

final class WordCardViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: WordCardPresenter

    private let disposeBag = DisposeBag()
    
    private let topBarView = WordCardTopBarView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func createUI() {
        view.backgroundColor = .white
        topBarView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
            }
        }
    }
    
    private func configureUI() {
        
        let topBarViewOutput = topBarView.configure(
            input: WordCardTopBarView.Input(studyState: .just(.fire))
        )
        
        topBarViewOutput.didTapBack
            .map { WordCardStep.home }
            .emit(to: steps)
            .disposed(by: disposeBag)
    }
}

private extension Reactive where Base: WordCardViewController {
    
}

