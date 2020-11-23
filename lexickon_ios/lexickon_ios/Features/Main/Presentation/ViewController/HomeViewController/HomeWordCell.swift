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
    private let progressView = WideWordProgressView()
    private let iconView = UIImageView()
    
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
            progressView,
            wordLable,
            iconView
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin
            .horizontally(Margin.regular)
            .vertically(Margin.regular/2)
        
        progressView.pin.all()
        
        iconView.pin
            .left(Margin.regular)
            .size(45)
            .vCenter()
        
        wordLable.pin
            .after(of: iconView)
            .marginLeft(Margin.small)
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
            wordLable.textColor = Asset.Colors.fireWordBright.color
            iconView.image = Asset.Images.wordMustReapetIcon.image
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Asset.Colors.fireWordPale.color,
                    progressColor: Asset.Colors.fireWord.color,
                    progress: 0.5
                )
            )
        case .ready:
            wordLable.textColor = Asset.Colors.readyWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Asset.Colors.readyWordPale.color,
                    progressColor: Asset.Colors.readyWord.color,
                    progress: 0.5
                )
            )
        case .new:
            wordLable.textColor = Asset.Colors.newWordBright.color
            iconView.image = Asset.Images.newWordIcon.image
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Asset.Colors.newWord.color,
                    progressColor: Asset.Colors.newWord.color,
                    progress: 0.5
                )
            )
        case .waiting:
            wordLable.textColor = Asset.Colors.waitingWordBright.color
            iconView.image = Asset.Images.waitingWordIcon.image
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Asset.Colors.waitingWordPale.color,
                    progressColor: Asset.Colors.waitingWord.color,
                    progress: 0.5
                )
            )
        }
    }
}

extension HomeWordCell: ClassIdentifiable {}
