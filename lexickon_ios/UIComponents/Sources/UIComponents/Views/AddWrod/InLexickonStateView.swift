//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 14.02.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets

public final class InLexickonStateView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        
        public init(state: State) {
            self.state = state
        }
        
        public enum State {
            case hasAsFireWord
            case hasAsNewWord
            case hasAsReadyWord
            case hasAsWaitingWord
            case hasnt
        }
        let state: State
    }
    
    private let disposeBag = DisposeBag()
    
    private let stateIconImageView = UIImageView(image: Asset.Images.WordRating.scale.image)
    fileprivate let stateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = .clear
        alpha = 0
        
        stateLabel.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.top.bottom.equalToSuperview()
                $0.width.equalTo(Size.icon.width)
            }
        }
        
        stateIconImageView.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(stateLabel.snp.right).offset(Margin.regular)
                $0.top.bottom.right.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        
    }
}
