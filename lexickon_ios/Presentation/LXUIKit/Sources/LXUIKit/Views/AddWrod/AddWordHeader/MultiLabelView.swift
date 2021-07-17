//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 01.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Assets
import UIExtensions
import RxExtensions

public final class MultiLabelView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private var titleIndex: Int = 0
    
    public struct Input {
        public init(
            titles: [String],
            changeDuration: RxTimeInterval = .seconds(3),
            animationDuration: CGFloat = 0.3
        ) {
            self.titles = titles
            self.changeDuration = changeDuration
            self.animationDuration = animationDuration
        }
        
        let titles: [String]
        let changeDuration: RxTimeInterval
        let animationDuration: CGFloat
    }
    
    public init() {
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let titleLabel = UILabel()
    
    private func createUI() {
        
        titleLabel.setup {
            $0.textAlignment = .center
            $0.textColor = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }

    public func configure(_ input: Input) {
        
        titleLabel.text = input.titles.first
        
        Signal<Int>.interval(input.changeDuration)
            .do(onNext: { _ in
                if self.titleIndex >= (input.titles.count - 1) {
                    self.titleIndex = 0
                } else {
                    self.titleIndex += 1
                }
        })
            .map { _ in input.titles[self.titleIndex] }
            .emit(to: titleLabel.rx.textWithAnimaiton)
            .disposed(by: disposeBag)
    }
}
