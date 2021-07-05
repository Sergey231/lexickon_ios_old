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
import LexickonStateEntity

final class WordCardViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: WordCardPresenter

    private let disposeBag = DisposeBag()
    
    private let word: WordEntity
    
    fileprivate let studyWordLabel = UILabel()
    fileprivate let translateLabel = UILabel()
    fileprivate let learnButton = UIButton()
    private let topBarView = WordCardTopBarView()
    private let progressView = WordCardProgressBarView()
    private let bottomBarView = WordCardBottomBarView()
    fileprivate let cantLearnHint = UILabel()
    
    init(word: WordEntity) {
        self.word = word
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
            $0.font = .bold18
            $0.textAlignment = .center
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(topBarView.snp.bottom).offset(Margin.huge)
            }
        }
        
        translateLabel.setup {
            $0.font = .regular17
            $0.textAlignment = .center
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(studyWordLabel.snp.bottom).offset(Margin.small)
            }
        }
        
        progressView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.top.equalTo(translateLabel.snp.bottom).offset(Margin.huge)
                $0.height.equalTo(200)
            }
        }
        
        bottomBarView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
        
        learnButton.setup {
            $0.alpha = 0
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.size.equalTo(Size.button)
                $0.bottom.equalTo(bottomBarView.snp.top).offset(-Margin.big)
            }
        }
        
        cantLearnHint.setup {
            $0.alpha = 0
            $0.text = "Когда настанет время,\n вы сможете закрепить это слово\n в упражнениях"
            $0.textColor = Colors.pale.color
            $0.textAlignment = .center
            $0.numberOfLines = 0
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalTo(bottomBarView.snp.top).offset(-Margin.big)
                $0.left.right.equalToSuperview()
            }
        }
    }
    
    private func configureUI() {
        
        let presenterOutput = presenter.configure(input: .init(word: word))
        let testWaitingTimePeriod: Int = 1209600 // (14 days)
        let testReadyTimePeriod: Int = 345600 // (4 days)
        let testFireTimePeriod: Int = 172800 // (2 days)
        
        let topBarViewOutput = topBarView.configure(
            input: WordCardTopBarView.Input(studyState: presenterOutput.studySate)
        )
        
        studyWordLabel.text = "Study Word"
        translateLabel.text = "Translate Word"
        
        learnButton.setTitle(Str.wordCardLearnButtonTitle, for: .normal)
        
        let bottomBarViewOutput = bottomBarView.configure(
            input: WordCardBottomBarView.Input(wordRaiting: .just(0.8))
        )
        
        _ = progressView.configure(
            input: .init(
                studyState: presenterOutput.studySate,
                wordLevel: .just(7),
                waitingTimePeriod: .just(testWaitingTimePeriod),
                readyTimePeriod: .just(testReadyTimePeriod),
                fireTimePariod: .just(testFireTimePeriod)
            )
        )
        
        topBarViewOutput.didTapBack
            .map { WordCardStep.home }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        bottomBarViewOutput.didTapAddWordButton
            .map { WordCardStep.addWord }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        presenterOutput.studySate
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: rx.studyState)
            .disposed(by: disposeBag)
        
        let canLearn = presenterOutput.studySate
            .map { $0 != .waiting }
        
        canLearn
            .map(!)
            .drive(learnButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        canLearn
            .drive(cantLearnHint.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

private extension Reactive where Base: WordCardViewController {
    
    var studyState: Binder<StudyState> {
        Binder(base) { base, stdudyState in
            var learnButtonColor: UIColor = .white
            switch stdudyState {
            
            case .fire:
                base.studyWordLabel.textColor = Colors.fireWordBright.color
                base.translateLabel.textColor = Colors.fireWordBright.color
                learnButtonColor = Colors.fireWordBright.color
            case .ready:
                base.studyWordLabel.textColor = Colors.readyWordBright.color
                base.translateLabel.textColor = Colors.readyWordBright.color
                learnButtonColor = Colors.readyWordBright.color
            case .new:
                base.studyWordLabel.textColor = Colors.newWordBright.color
                base.translateLabel.textColor = Colors.newWordBright.color
                learnButtonColor = Colors.newWordBright.color
            case .waiting:
                base.studyWordLabel.textColor = Colors.waitingWordBright.color
                base.translateLabel.textColor = Colors.waitingWordBright.color
                learnButtonColor = Colors.waitingWordBright.color
            }
            
            base.learnButton.setRoundedBorderedStyle(
                bgColor: .white,
                borderColor: learnButtonColor
            )
            UIView.animate(withDuration: 0.6, delay: 1) {
                base.learnButton.alpha = 1
                base.cantLearnHint.alpha = 1
            }
        }
    }
}

