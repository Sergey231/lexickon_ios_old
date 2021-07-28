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
    private let colorBoxView = WordsCountView()
    private let greenBoxView = WordsCountView()
    
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
                $0.top.equalToSuperview()
                $0.left.right.equalToSuperview()
                $0.height.equalTo(Size.textField.height)
            }
        }
        
        stackView.setup {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom)
                $0.bottom.equalToSuperview()
            }
        }
        
        yellowBoxView.setup {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(48)
            }
        }
        
        colorBoxView.setup {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(48)
            }
        }
        
        greenBoxView.setup {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(48)
            }
        }
    }
    
    public func configure(input: Input) {
        
        _ = yellowBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.yellowBoxIcon.image,
                count: 23,
                description: "Новых"
            )
        )
        
        _ = colorBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.colorBoxIcon.image,
                count: 654,
                description: "В процессе"
            )
        )
        
        _ = greenBoxView.configure(
            input: WordsCountView.Input(
                icon: Images.Profile.greenBoxIcon.image,
                count: 334,
                description: "Выученх (более 6 мес.)"
            )
        )
    }
}
