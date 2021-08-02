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
        
        let newWordsCount: UInt
        let oneDayWordsCount: UInt
        let oneWeekWordsCount: UInt
        let oneMonthWordsCount: UInt
        let halfYearWordsCount: UInt
        
        public init(
            newWordsCount: UInt,
            oneDayWordsCount: UInt,
            oneWeekWordsCount: UInt,
            oneMonthWordsCount: UInt,
            halfYearWordsCount: UInt
        ) {
            self.newWordsCount = newWordsCount
            self.oneDayWordsCount = oneDayWordsCount
            self.oneWeekWordsCount = oneMonthWordsCount
            self.oneMonthWordsCount = oneMonthWordsCount
            self.halfYearWordsCount = halfYearWordsCount
        }
    }
    
    private let yellowBoxView = WordsCountView()
    private let colorBoxView = WordsCountView()
    private let greenBoxView = WordsCountView()
    private let authoaddingOfWordsButton = UIButton()
    
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let autoAddingWordsSettings = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        titleLabel.setup {
            $0.font = .regular17
            $0.textColor = Colors.baseText.color
            $0.text = Str.profileVocabularyViewTitle
            $0.textAlignment = .center
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.right.equalToSuperview()
                $0.height.equalTo(Size.textField.height)
            }
        }
        
        stackView.setup {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.spacing = Margin.regular
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom).offset(Margin.regular)
            }
        }
        
        [yellowBoxView, colorBoxView, greenBoxView].forEach {
            $0.setup {
                stackView.addArrangedSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(48)
                }
            }
        }
        
        authoaddingOfWordsButton.setup {
            $0.setTitle(Str.profielVocabularyAutoaddingWordsButtonTitle, for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom).offset(Margin.mid)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(Size.button)
                $0.bottom.bottom.equalToSuperview().offset(-Margin.big)
            }
        }
    }
    
    public func configure(input: Input) {
        
        _ = yellowBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.yellowBoxIcon.image,
                count: input.newWordsCount,
                description: Str.profileVocabularyNewWordsTitle
            )
        )
        
        let inProcessWordsCount = input.oneDayWordsCount
            + input.oneWeekWordsCount
            + input.oneMonthWordsCount
        
        _ = colorBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.colorBoxIcon.image,
                count: inProcessWordsCount,
                description: Str.profileVocabularyInProgressWordsTitle
            )
        )
        
        _ = greenBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.greenBoxIcon.image,
                count: input.halfYearWordsCount,
                description: Str.profileVocabularyDoneWordsTitle
            )
        )
        
        authoaddingOfWordsButton.setRoundedBorderedStyle(
            bgColor: .white,
            borderColor: Colors.gold.color
        )
    }
}
