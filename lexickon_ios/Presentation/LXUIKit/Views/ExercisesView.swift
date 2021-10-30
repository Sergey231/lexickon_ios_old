//
//  ExercisesView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import Resolver

public final class ExercisesView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    private let exercisesNavigationController = UINavigationController()
    private let endSessionRelay = PublishRelay<Void>()
    
    public struct Input {
        public init(
            session: ExercisesSessionEntity,
            parentViewController: UIViewController
        ) {
            self.session = session
            self.parentViewController = parentViewController
        }
        let session: ExercisesSessionEntity
        let parentViewController: UIViewController
    }
    
    public struct Output {
        let endSession: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        
    }
    
    public func configure(input: Input) -> Output {
        
        exercisesNavigationController.setup {
            $0.willMove(toParent: input.parentViewController)
            input.parentViewController.view.addSubview($0.view)
            input.parentViewController.addChild($0)
            $0.view.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(input.parentViewController.view.safeAreaLayoutGuide.snp.top)
            }
            $0.didMove(toParent: input.parentViewController)
        }
        
        guard let initExerciseType = input.session.currentSessionWord?.currentExercise else {
            return Output(endSession: .just(()))
        }
        
        switch initExerciseType {
        case .wordView:
            let wordViewExerciseViewController: WordViewExerciseViewController = Resolver.resolve()
            exercisesNavigationController.setViewControllers([wordViewExerciseViewController], animated: true)
        case .none:
            break
        }
        
        return Output(endSession: endSessionRelay.asSignal())
    }
}
