//
//  ExercisesResultsViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import SnapKit
import UIExtensions
import RxExtensions
import Resolver
import Assets
import LBTATools

class ExercisesResultViewController: UIViewController, Stepper {
    
    struct UIConstants {
        
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected private var presenter: ExercisesResultPresenter
    
    private let button = UIButton()
    
    private let disposeBag = DisposeBag()
    
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
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }

    //MARK: Create UI
    private func createUI() {
        view.backgroundColor = .white
        
        button.setup {
            $0.setTitle("Ok", for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(Size.button)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Margin.mid)
            }
        }
    }
    
    //MARK: Configure UI
    private func configureUI() {
        button.setRoundedBorderedStyle(
            bgColor: Colors.mainBG.color,
            borderColor: Colors.mainBG.color,
            titleColor: .white
        )
        
        button.configureTapScaleAnimation()
            .disposed(by: disposeBag)
        
        button.rx.tap.asSignal()
            .map { _ in ExercisesStep.home(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
    }
}
