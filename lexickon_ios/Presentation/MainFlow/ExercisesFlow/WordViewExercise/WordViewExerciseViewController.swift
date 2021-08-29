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
import LBTATools

class WordViewExerciseViewController: UIViewController, Stepper {
    
    struct UIConstants {
        
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: WordViewExercisePresenter
    
    private let disposeBag = DisposeBag()
    
    private let titleView = ExercisesTitleView()
    private let wordStackView = UIView()
    private let studyWordLabel = UILabel()
    private let translationLabel = UILabel()
    private let button = UIButton()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        UIView.animate(withDuration: 0.3) { [unowned self] in
            wordStackView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Margin.huge)
            }
            // Для того игнорирования стартовой анимации
            if view.safeAreaInsets.top > 47 {
                view.layoutIfNeeded()
            }
        }
    }

    //MARK: Create UI
    
    private func createUI() {
        
        titleView.setup {
            $0.frame = .init(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 44
            )
            navigationItem.titleView = $0
        }
        
        wordStackView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Margin.huge)
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
            }
        }
        
        studyWordLabel.setup {
            $0.font = .regular32
            $0.textAlignment = .center
        }
        
        translationLabel.setup {
            $0.font = .regular24
            $0.textAlignment = .center
        }
        
        wordStackView.stack(
            studyWordLabel,
            translationLabel,
            spacing: 50
        )
    }
    
    //MARK: Configure UI
    
    private func configureUI() {
        
        let titleVIewOutput = titleView.configure(input: ExercisesTitleView.Input())
        navigationItem.largeTitleDisplayMode = .never
        
        titleVIewOutput.closeDidTap
            .map { ExercisesStep.home(animated: true) }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        studyWordLabel.text = "Knife"
        translationLabel.text = "Нож"
    }
}
