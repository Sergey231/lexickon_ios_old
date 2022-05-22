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
import LBTATools

class ExercisesResultViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()
    
    @Injected private var presenter: ExercisesResultPresenter
    
    private let label = UILabel()
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
        
        label.setup {
            $0.text = "😉"
            $0.textAlignment = .center
            $0.font = .regular32
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
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
        
        let presenterOutput = presenter.configure(
            input: .init(submitButtonDidTap: button.rx.tap.asSignal())
        )
        
        presenterOutput.sessionDidFinish
            .map { _ in ExercisesSessionStep.home(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
    }
}
