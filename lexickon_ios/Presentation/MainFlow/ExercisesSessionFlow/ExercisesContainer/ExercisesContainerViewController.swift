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
    private let button = UIButton()
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
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        titleView.setup {
            guard let windows = (UIApplication.shared.windows.first { $0.isKeyWindow }) else {
                return
            }
            windows.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(windows.safeAreaInsets.top)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(windows.bounds.width)
                $0.height.equalTo(44)
            }
        }
        
        button.setup {
            UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(button)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.size.equalTo(Size.button)
                $0.bottom.equalToSuperview().offset(-Margin.huge)
            }
        }
    }
    
    //MARK: Configure UI
    
    private func configureUI() {
        
        let progressRelay = BehaviorRelay<CGFloat>(value: 0)
        
        let titleViewOutput = titleView.configure(input: .init(value: progressRelay.asDriver()))
        navigationItem.largeTitleDisplayMode = .never
        
        titleViewOutput.closeDidTap
            .do { [unowned self] _ in
                button.removeFromSuperview()
                titleView.removeFromSuperview()
            }
            .map { ExercisesSessionStep.home(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        let presenterOutput = presenter.configure(
            input: .init(exerciseDidDone: button.rx.tap.asSignal())
        )
        
        guard let currentSession = presenterOutput.currentSession else {
            steps.accept(ExercisesSessionStep.home(animated: true))
            return
        }
        
        currentSession.sessionProgress
            .drive(progressRelay)
            .disposed(by: disposeBag)
        
        // При нинициализации, ExercissesView сома распологается во ViewController,
        // который предедается в параметре parentViewController
        let exercisesViewOutput = exercisesView.configure(
            input: .init(
                nextExerciseType: presenterOutput.nextExerciseType,
                session: currentSession,
                parentViewController: self
            )
        )
        
        presenterOutput.nextExerciseType
            .filter { $0 == .none }
            .do { [unowned self] _ in
                button.removeFromSuperview()
                titleView.removeFromSuperview()
            }
            .map { _ in ExercisesSessionStep.result }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        button.configureRoundedFilledStyle(
            fillColor: Colors.mainBG.color,
            titleColor: .white
        )
        
        button.configureTapScaleAnimation()
            .disposed(by: disposeBag)
        
        button.setTitle("Далее", for: .normal)
        
        exercisesViewOutput.endSession
            .debug("💪🏻")
            .emit()
            .disposed(by: disposeBag)
    }
}
