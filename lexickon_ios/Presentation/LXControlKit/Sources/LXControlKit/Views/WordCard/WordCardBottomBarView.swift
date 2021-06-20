//
//  WordCardBottomBarView.swift
//  
//
//  Created by Sergey Borovikov on 18.06.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import LexickonApi

public final class WordCardBottomBarView: UIView {
    
    fileprivate struct UIConstants {
        static let addButtonSize: CGFloat = 56
    }
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(distributionStatus: Driver<CGFloat>) {
            self.distributionStatus = distributionStatus
        }
        let distributionStatus: Driver<CGFloat>
    }
    
    public struct Output {
        public let didTapSpeekerButton: Signal<Void>
        public let didTapdistributionStatusButton: Signal<Void>
        public let didTapAddWordButton: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let speekButtonImageView = UIImageView()
    fileprivate let addWordButton = AddWordButton()
    fileprivate let wordDistributionIconView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        speekButtonImageView.setup {
            $0.image = Images.speekerIcon.image
            $0.tintColor = .lightGray
            addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(Size.icon)
            }
        }
        
        addWordButton.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-Margin.big)
                $0.centerY.equalTo(speekButtonImageView.snp.centerY)
                $0.size.equalTo(UIConstants.addButtonSize)
            }
        }
        
        wordDistributionIconView.setup {
            $0.backgroundColor = .red
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(speekButtonImageView.snp.centerY)
                $0.size.equalTo(56)
                $0.left.equalToSuperview().offset(Margin.big)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        return Output(
            didTapSpeekerButton: .empty(),
            didTapdistributionStatusButton: .empty(),
            didTapAddWordButton: .empty()
        )
    }
}

private extension Reactive where Base : WordCardTopBarView {
   
}


