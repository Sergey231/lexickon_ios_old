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
    
    fileprivate let exercisesNavigationController = UINavigationController()
    private let nextExerciseTypeRelay = PublishRelay<ExercisesSessionEntity.ExerciseType>()
    private let endSessionRelay = PublishRelay<Void>()
    
//    fileprivate let wordViewExerciseViewController: WordViewExerciseViewController = Resolver.resolve()
    
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
        
        nextExerciseTypeRelay.asSignal()
            .emit(to: rx.nextExerciseType)
            .disposed(by: disposeBag)
        
        exercisesNavigationController.setup {
            $0.willMove(toParent: input.parentViewController)
            input.parentViewController.view.addSubview($0.view)
            input.parentViewController.addChild($0)
            $0.view.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-80)
                $0.top.equalTo(input.parentViewController.view.safeAreaLayoutGuide.snp.top)
            }
            $0.didMove(toParent: input.parentViewController)
        }
        
        guard let initExerciseType = input.session.currentSessionWord?.currentExercise else {
            return Output(endSession: .just(()))
        }
        
        nextExerciseTypeRelay.accept(initExerciseType)
        
        return Output(endSession: endSessionRelay.asSignal())
    }
}

private extension Reactive where Base: ExercisesView {
    var nextExerciseType: Binder<ExercisesSessionEntity.ExerciseType> {
        Binder(base) { base, exerciseType in
            switch exerciseType {
                
            case .wordView:
                let wordViewExerciseViewController: WordViewExerciseViewController = Resolver.resolve()
                base.exercisesNavigationController.setViewControllers([wordViewExerciseViewController], animated: true)
            case .none:
                break
            }
        }
    }
}
