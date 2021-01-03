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

final class HomeWordsSectionHeaderView: UIView {
    
    enum StudyWordsType: Int {
        case fire
        case ready
        case new
        case waiting
        
        var title: String {
            switch self {
            
            case .fire:
                return L10n.homeFireSectionTitle
            case .ready:
                return L10n.homeReadySectionTitle
            case .new:
                return L10n.homeNewSectionTitle
            case .waiting:
                return L10n.homeWaitingSectionTitle
            }
        }
    }
    
    struct Input {
        let studyWordsType: StudyWordsType
    }
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemRegular12
        title.textColor = .lightGray
        return title
    }()
    
    private let bgTitleView: UIView = {
        let bg = UIView()
        bg.backgroundColor = Asset.Colors.homeWordSectionHeaderBG.color
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        addSubview(bgTitleView)
        bgTitleView.addSubview(titleLabel)
        
        bgTitleView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(-Margin.regular/2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Margin.mid)
            $0.right.equalToSuperview().offset(-Margin.mid)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func configure(input: Input) {
        titleLabel.text = input.studyWordsType.title
    }
}
