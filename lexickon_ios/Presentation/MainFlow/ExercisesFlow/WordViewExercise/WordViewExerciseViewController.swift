//
//  WordViewExerciseViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 20.08.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import SnapKit
import LXUIKit
import UIExtensions
import RxExtensions
import Resolver
import Assets

class WordViewExerciseViewController: UIViewController, Stepper {
    
    struct UIConstants {
        
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: WordViewExercisePresenter
    
    private let disposeBag = DisposeBag()
    
    private let closeButton = UIButton()
    
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
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            steps.accept(ProfileStep.addWord)
        }
    }
    
    //MARK: Create UI
    
    private func createUI() {

        closeButton.setup {
            $0.setImage(Images.closeIcon.image, for: .normal)
            $0.tintColor = .gray
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.size.equalTo(56)
                $0.left.equalToSuperview()
            }
        }
    }
    
    //MARK: Configure UI
    
    private func configureUI() {
        view.backgroundColor = .gray
        
        closeButton.rx.tap
            .asSignal()
            .map { ExercisesStep.home(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
    }
}

