//
//  WordCardTopBarView.swift
//  
//
//  Created by Sergey Borovikov on 15.06.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import LexickonApi

public final class WordCardTopBarView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(studyState: Driver<StudyType>) {
            self.studyState = studyState
        }
        let studyState: Driver<StudyType>
    }
    
    public struct Output {
        let didTap: Signal<Void>
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
        backgroundColor = .gray
    }
    
    public func configure(input: Input) -> Output {
        
    }
}

private extension Reactive where Base : WordCardTopBarView {
    
}

