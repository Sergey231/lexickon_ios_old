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
import LexickonApi

final class WordCardViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: WordCardPresenter

    private let disposeBag = DisposeBag()
    
    fileprivate let studyWordLabel = UILabel()
    fileprivate let translateLabel = UILabel()
    private let topBarView = WordCardTopBarView()
    private let bottomBarView = WordCardBottomBarView()
    
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
        
        studyWordLabel.setup {
            $0.font = .systemRegular24
            $0.textAlignment = .center
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(topBarView.snp.bottom).offset(Margin.huge)
            }
        }
        
        translateLabel.setup {
            $0.font = .systemRegular17
            $0.textAlignment = .center
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(studyWordLabel.snp.bottom).offset(Margin.small)
            }
        }
        
        bottomBarView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func configureUI() {
        
        let topBarViewOutput = topBarView.configure(
            input: WordCardTopBarView.Input(studyState: .just(.fire))
        )
        
        studyWordLabel.text = "Study Word"
        translateLabel.text = "Translate Word"
        
        let bottomBarViewOutput = bottomBarView.configure(
            input: WordCardBottomBarView.Input(wordRaiting: .just(0.8))
        )
        
        topBarViewOutput.didTapBack
            .map { WordCardStep.home }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        bottomBarViewOutput.didTapAddWordButton
            .map { WordCardStep.addWord }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        Signal.just(StudyType.fire)
            .emit(to: rx.studyState)
            .disposed(by: disposeBag)
    }
}

private extension Reactive where Base: WordCardViewController {
    
    var studyState: Binder<StudyType> {
        Binder(base) { base, stdudyState in
            switch stdudyState {
            
            case .fire:
                base.studyWordLabel.textColor = Colors.fireWordBright.color
                base.translateLabel.textColor = Colors.fireWordBright.color
            case .ready:
                base.studyWordLabel.textColor = Colors.readyWordBright.color
                base.translateLabel.textColor = Colors.readyWordBright.color
            case .new:
                base.studyWordLabel.textColor = Colors.newWordBright.color
                base.translateLabel.textColor = Colors.newWordBright.color
            case .waiting:
                base.studyWordLabel.textColor = Colors.waitingWordBright.color
                base.translateLabel.textColor = Colors.waitingWordBright.color
            }
        }
    }
}

