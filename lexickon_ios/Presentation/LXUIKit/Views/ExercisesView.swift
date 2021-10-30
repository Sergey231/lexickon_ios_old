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

public final class ExercisesView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    private let didTapNextRelay = PublishRelay<Void>()
    
    public struct Input {
        public init(
            parentViewController: UIViewController
        ) {
            self.parentViewController = parentViewController
        }
        let parentViewController: UIViewController
    }
    
    public struct Output {
        let didTapNext: Signal<Void>
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
        
        return Output(didTapNext: didTapNextRelay.asSignal())
    }
}
