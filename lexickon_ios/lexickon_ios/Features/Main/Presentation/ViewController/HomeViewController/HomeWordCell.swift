//
//  HomeWordCell.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 03.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa
import Utils
import RxDataSources
import UIExtensions

struct HomeWordViewModel {
    
    enum StudyType {
        case fire
        case ready
        case new
        case waiting
    }
    
    let word: String
    let studyType: StudyType
}

extension HomeWordViewModel: Hashable {
    static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.word == rsh.word
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

extension HomeWordViewModel: IdentifiableType {
    var identity: String {
        return self.word
    }
    typealias Identity = String
}

class HomeWordCell: DisposableTableViewCell {

    private let wordLable = UILabel()
    private let bgView = UIView()
    private let progressView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        contentView.addSubviews(
            bgView,
            progressView,
            wordLable
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        contentView.pin
            .horizontally(Margin.regular)
            .vertically(Margin.regular/2)
        
        bgView.pin.all()
        
        progressView.pin
            .all(Margin.small)
        
        wordLable.pin
            .horizontally(Margin.regular)
            .sizeToFit(.heightFlexible)
            .vCenter()
    }
    
    private func configureUI() {
        progressView.layer.cornerRadius = 13
        wordLable.font = .systemRegular24
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    func configurate(with model: HomeWordViewModel) {
        
        wordLable.text = model.word
        
        switch model.studyType {
            
        case .fire:
            bgView.backgroundColor = Asset.Colors.fireWordProgressBG.color
            progressView.backgroundColor = Asset.Colors.fireWordProgress.color
            wordLable.textColor = Asset.Colors.fireWord.color
        case .ready:
            bgView.backgroundColor = Asset.Colors.readyWordProgressBG.color
            progressView.backgroundColor = Asset.Colors.readyWordProgress.color
        case .new:
            bgView.backgroundColor = Asset.Colors.newWordProgress.color
            progressView.backgroundColor = Asset.Colors.newWordProgress.color
        case .waiting:
            bgView.backgroundColor = Asset.Colors.waitingWordProgressBG.color
            progressView.backgroundColor = Asset.Colors.waitingWordProgress.color
        }
    }
    
}

extension HomeWordCell: ClassIdentifiable {}
