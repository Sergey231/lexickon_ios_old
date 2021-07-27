//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 24.07.2021.
//

import RxSwift
import RxCocoa
import UIKit
import Assets
import SnapKit

public final class VocabularyView: UIView {
    
    public struct Input {
        public init() {}
    }
    
    private let yellowBoxView = WordsCountView()
    
    private let titleLabel = UILabel()
    private let vocabularyStackView = UIStackView()
    private let autoAddingWordsSettings = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        // test
        backgroundColor = .lightGray
        
        snp.makeConstraints {
            $0.height.equalTo(300)
        }
        
        titleLabel.setup {
            $0.font = .regular17
            $0.textColor = Colors.baseText.color
            $0.text = Str.profileVocabularyViewTitle
            $0.textAlignment = .center
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(Size.textField.height)
            }
        }
        
        vocabularyStackView.setup {
            $0.axis = .vertical
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom)
                $0.bottom.equalToSuperview()
            }
        }
        
        yellowBoxView.setup {
            addSubviews($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom)
                $0.height.equalTo(48)
            }
        }
    }
    
    public func configure(input: Input) {
        
        yellowBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.yellowBoxIcon.image,
                count: 23,
                description: "Новых"
            )
        )
    }
}
