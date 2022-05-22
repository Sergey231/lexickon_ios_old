//
//  HomeWordsSectionHeaderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import UIExtensions
import SnapKit
import LexickonApi

public final class HomeWordsSectionHeaderView: UIView {
    
    public struct Input {
        public init(studyState: LxStudyState) {
            self.studyState = studyState
        }
        let studyState: LxStudyState
    }
    
    private let titleLabel = UILabel()
    private let bgTitleView = UIView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        bgTitleView.setup {
            $0.backgroundColor = Colors.baseBG.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(-Margin.regular/2)
            }
        }
        
        titleLabel.setup {
            $0.font = .regular12
            $0.textColor = .lightGray
            bgTitleView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.top.bottom.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        
        var title: String {
            switch input.studyState {
            case .fire:
                return Str.homeFireSectionTitle
            case .ready:
                return Str.homeReadySectionTitle
            case .new:
                return Str.homeNewSectionTitle
            case .waiting:
                return Str.homeWaitingSectionTitle
            case .downgradeRating:
                return "Рейтинг некоторых слов начел снижаться:("
            }
        }
        
        titleLabel.text = title
    }
}
