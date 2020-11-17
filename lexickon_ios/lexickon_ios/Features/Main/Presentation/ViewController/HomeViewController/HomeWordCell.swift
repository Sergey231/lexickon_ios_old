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
        
        progressView.alpha = 0.4
        progressView.layer.cornerRadius = 12
        
        bgView.alpha = 0.4
        
        wordLable.font = .systemRegular24
        wordLable.alpha = 0.3
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    func configurate(with model: HomeWordViewModel) {
        
        wordLable.text = model.word
        
        switch model.studyType {
            
        case .fire:
            bgView.backgroundColor = .red
            progressView.backgroundColor = .red
        case .ready:
            bgView.backgroundColor = .green
            progressView.backgroundColor = .green
        case .new:
            bgView.backgroundColor = .yellow
            progressView.backgroundColor = .yellow
        case .waiting:
            bgView.backgroundColor = .gray
            progressView.backgroundColor = .gray
        }
    }
    
}

extension HomeWordCell: ClassIdentifiable {}
