//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 01.04.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets

public final class SubmenuItem: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(
            title: Driver<String>,
            emojiIcon: Driver<String> = .just("😀"),
            titleColor: UIColor = Colors.baseText.color
        ) {
            self.title = title
            self.emojiIcon = emojiIcon
            self.titleColor = titleColor
        }
        let title: Driver<String>
        let emojiIcon: Driver<String>
        let titleColor: UIColor
    }
    
    public struct Output {
        public let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let emojiIcon = UILabel()
    private let titleLabel = UILabel()
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        emojiIcon.setup {
            $0.font = .regular24
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.width.equalTo(32)
                $0.top.bottom.equalToSuperview()
            }
        }
        
        titleLabel.setup {
            $0.textAlignment = .left
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(emojiIcon.snp.right).offset(Margin.regular)
                $0.right.equalToSuperview().offset(Margin.regular)
                $0.top.bottom.equalToSuperview()
            }
        }
        
        button.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        input.emojiIcon
            .drive(emojiIcon.rx.text)
            .disposed(by: disposeBag)
        
        titleLabel.textColor = input.titleColor
        
        return Output(didTap: button.rx.tap.asSignal())
    }
}
