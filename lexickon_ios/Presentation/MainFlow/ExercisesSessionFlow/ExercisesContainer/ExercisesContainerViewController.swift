//
//  ExercisesContainerViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.10.2021.
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

final class ExercisesContainerViewController: UIViewController, Stepper {

    private let titleView = ExercisesTitleView()
    private let exercisesView = ExercisesView()
    private let disposeBag = DisposeBag()

    @Injected private var presenter: ExercisesPresenter
    
    let steps = PublishRelay<Step>()
    
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
        view.backgroundColor = .green
        createUI()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    //MARK: Create UI
    
    private func createUI() {
        
        view.backgroundColor = .green
        
        titleView.setup {
            $0.frame = .init(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 44
            )
            navigationItem.titleView = $0
        }
        
    }
    
    //MARK: Configure UI
    
    private func configureUI() {
        
        let titleVIewOutput = titleView.configure(input: .init(value: .just(0.5)))
        navigationItem.largeTitleDisplayMode = .never
        
        titleVIewOutput.closeDidTap
            .map { ExercisesSessionStep.home(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        let presenterOutput = presenter.configure(input: ExercisesPresenter.Input())
        
        guard let currentSession = presenterOutput.currentSession else {
            steps.accept(ExercisesSessionStep.home(animated: true))
            return
        }
        
        let exercisesViewOutput = exercisesView.configure(
            input: .init(
                session: currentSession,
                parentViewController: self
            )
        )
        
        exercisesViewOutput.endSession
            .debug("💪🏻")
            .emit()
            .disposed(by: disposeBag)
    }
}
