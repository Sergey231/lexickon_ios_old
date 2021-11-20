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
import UIExtensions
import RxExtensions
import Resolver
import Assets
import LBTATools

class WordViewExerciseViewController: UIViewController {
    
    struct UIConstants {
        
    }
    
    private let didTapSubmitButton = PublishRelay<Void>()
    private let nextSessionItem: ExercisesSessionEntity.NextSessionItem = .emptyItem
    
    @Injected var presenter: WordViewExercisePresenter
    
    private let disposeBag = DisposeBag()
    
    private let wordStackView = UIView()
    private let studyWordLabel = UILabel()
    private let translationLabel = UILabel()
    
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
            $0.alpha = 0
        }
        
        wordStackView.stack(
            studyWordLabel,
            translationLabel,
            spacing: 50
        )
    }
    
    //MARK: Configure UI
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        rx.viewDidAppear
            .asDriver(onErrorDriveWith: .empty())
            .map { 1 }
            .drive(translationLabel.rx.alphaSlowAnimated)
            .disposed(by: disposeBag)
        
        let presenterOutput = presenter.configure(
            input: .init(
                nextSessionItem: nextSessionItem
            )
        )
        
        studyWordLabel.text = presenterOutput.studyWord
        translationLabel.text = presenterOutput.translation
    }
}
