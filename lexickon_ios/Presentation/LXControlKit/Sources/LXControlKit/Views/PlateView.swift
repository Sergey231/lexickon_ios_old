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

public final class PlateView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(
            title: Driver<String>,
            titleColor: UIColor = .lightGray
        ) {
            self.title = title
            self.titleColor = titleColor
        }
        let title: Driver<String>
        let titleColor: UIColor
    }
    
    public struct Output {
        public let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
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
        backgroundColor = .white
        layer.cornerRadius = CornerRadius.big
        setShadow()
        titleLabel.setup {
            $0.textAlignment = .center
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
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
        
        titleLabel.textColor = input.titleColor
        
        return Output(didTap: button.rx.tap.asSignal())
    }
}
