//
//  HomeWordsSectionHeaderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import UIExtensions

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
    
    private let titleLabel = UILabel()
    private let bgTitleView = UIView()
    private let bottomGapView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgTitleView.pin
            .horizontally()
            .top()
            .bottom(Margin.regular/2)
        
        bottomGapView.pin
            .horizontally()
            .below(of: bgTitleView)
            .bottom()
        
        titleLabel.pin
            .horizontally(Margin.mid)
            .vertically()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(bgTitleView, bottomGapView)
        bgTitleView.addSubview(titleLabel)
    }
    
    private func configureUI() {
        bgTitleView.backgroundColor = Asset.Colors.homeWordSectionHeaderBG.color
        titleLabel.font = .systemRegular12
        titleLabel.textColor = .lightGray
        
        bottomGapView.backgroundColor = .clear
    }
    
    func configure(input: Input) {
        titleLabel.text = input.studyWordsType.title
    }
}
