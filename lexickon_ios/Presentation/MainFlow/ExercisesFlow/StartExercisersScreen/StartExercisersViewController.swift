//
//  StartExercisersViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.09.2021.
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

class StartExercisesViewController: UIViewController, Stepper {
    
    struct UIConstants {
        
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected private var presenter: StartExercisesPresenter
    
    private let disposeBag = DisposeBag()
    
    private let activityView = UIActivityIndicatorView()
    private let wordsForExercisesLabel = UILabel()
    
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    //MARK: Create UI
    private func createUI() {
        
        activityView.setup {
            $0.startAnimating()
            $0.tintColor = .gray
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        wordsForExercisesLabel.setup {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .lightGray
            $0.font = .regular24
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.big)
                $0.right.equalToSuperview().offset(-Margin.big)
                $0.top.equalTo(activityView.snp.bottom).offset(Margin.regular)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Margin.huge)
            }
        }
    }
    
    //MARK: Configure UI
    private func configureUI() {
        let presenterOutput = presenter.configure(input: .init())
        presenterOutput.execisesSessionEntity.debug("👨🏻")
            .emit(onNext: { [unowned self] in
                print($0.sessionWords)
                wordsForExercisesLabel.text = $0.sessionWords.reduce("", { result, sesstionWordEntity in
                    var result = result
                    result?.append("\n\(sesstionWordEntity.word.studyWord)")
                    return result
                })
            })
            .disposed(by: disposeBag)
    }
}

