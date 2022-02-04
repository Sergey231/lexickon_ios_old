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
    private let nextSessionItemRelay = PublishRelay<ExercisesSessionEntity.NextSessionItem>()
    fileprivate let endSessionRelay = PublishRelay<Void>()
    
//    fileprivate let wordViewExerciseViewController: WordViewExerciseViewController = Resolver.resolve()
    
    public struct Input {
        public init(
            nextSessionItem: Signal<ExercisesSessionEntity.NextSessionItem>,
            session: ExercisesSessionEntity,
            parentViewController: UIViewController
        ) {
            self.nextSessionItem = nextSessionItem
            self.session = session
            self.parentViewController = parentViewController
        }
        let nextSessionItem: Signal<ExercisesSessionEntity.NextSessionItem>
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
        
        nextSessionItemRelay.asSignal()
            .emit(to: rx.nextSessionItem)
            .disposed(by: disposeBag)
        
        exercisesNavigationController.setup {
            $0.willMove(toParent: input.parentViewController)
            input.parentViewController.view.addSubview($0.view)
            input.parentViewController.addChild($0)
            $0.view.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.top.equalTo(input.parentViewController.view.safeAreaLayoutGuide.snp.top)
            }
            $0.didMove(toParent: input.parentViewController)
        }
        
        let initSessionItem = input.session.currentSessionItem
        
        nextSessionItemRelay.accept(initSessionItem)
        
        input.nextSessionItem
            .emit(to: rx.nextSessionItem)
            .disposed(by: disposeBag)
        
        return Output(endSession: endSessionRelay.asSignal())
    }
}

private extension Reactive where Base: ExercisesView {
    var nextSessionItem: Binder<ExercisesSessionEntity.NextSessionItem> {
        Binder(base) { base, nextSessionItem in
            switch nextSessionItem.exercise {
            case .wordView:
                let wordViewExerciseViewController: WordViewExerciseViewController = Resolver.resolve(args: nextSessionItem)
                base.exercisesNavigationController.setViewControllers([wordViewExerciseViewController], animated: true)
            case .none:
                base.endSessionRelay.accept(())
            }
        }
    }
}
