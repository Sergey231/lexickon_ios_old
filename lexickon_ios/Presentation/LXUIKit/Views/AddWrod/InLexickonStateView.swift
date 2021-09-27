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
            
            public var stateColor: UIColor {
                switch self {
                case .hasAsFireWord:
                    return Colors.fireWordBright.color
                case .hasAsNewWord:
                    return Colors.newWordBright.color
                case .hasAsReadyWord:
                    return Colors.readyWordBright.color
                case .hasAsWaitingWord:
                    return Colors.waitingWordBright.color
                case .hasnt:
                    return Colors.paleText.color
                }
            }
            
            public var stateText: String {
                switch self {
                case .hasnt:
                    return Str.inLexickonStateHasnt
                default:
                    return Str.inLexickonStateHas
                }
            }
        }
        let state: State
    }
    
    private let disposeBag = DisposeBag()
    
    private let stateIconImageView = UIImageView(image: Images.imageLogo.image)
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
        
        stateIconImageView.setup {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = Colors.fireWordBright.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.top.bottom.equalToSuperview()
                $0.width.equalTo(16)
            }
        }
        
        stateLabel.setup {
            $0.font = .regular12
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(stateIconImageView.snp.right).offset(Margin.small)
                $0.top.bottom.right.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        stateLabel.textColor = input.state.stateColor
        stateLabel.text = input.state.stateText
        stateIconImageView.tintColor = input.state.stateColor
        switch input.state {
        case .hasnt:
            stateIconImageView.snp.updateConstraints {
                $0.width.equalTo(0)
            }
            stateLabel.snp.updateConstraints {
                $0.left.equalTo(stateIconImageView.snp.right).offset(0)
            }
        default:
            stateIconImageView.snp.updateConstraints {
                $0.width.equalTo(16)
            }
            stateLabel.snp.updateConstraints {
                $0.left.equalTo(stateIconImageView.snp.right).offset(Margin.small)
            }
        }
        
    }
}
