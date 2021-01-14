//
//  HomeWordCell.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 03.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils
import RxDataSources
import UIExtensions
import RxExtensions

struct HomeWordViewModel {
    
    enum StudyType {
        case fire
        case ready
        case new
        case waiting
    }
    
    var isReady: Bool { self.studyType == .ready }
    
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
    
    private let wordLable: UILabel = {
        let label = UILabel()
        label.font = .systemRegular24
        return label
    }()
    
    private let progressView: WideWordProgressView = {
        let view = WideWordProgressView()
        view.layer.cornerRadius = 13
        return view
    }()
    
    private lazy var iconImageView = UIImageView()
    private lazy var logo = Logo()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: HomeWordViewModel) {
        contentView.addSubviews(
            progressView,
            wordLable
        )
        contentView.addSubview(input.isReady ? logo : iconImageView)
        
        contentView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-Margin.regular)
            $0.left.equalToSuperview().offset(Margin.regular)
            $0.top.equalToSuperview().offset(Margin.regular)
            $0.bottom.equalToSuperview().offset(-Margin.regular/2)
        }
        
        progressView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layout(with input: HomeWordViewModel) {
        
        if input.isReady {
            
            logo.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }
            
            wordLable.snp.makeConstraints {
                $0.left.equalTo(logo.snp.right).offset(Margin.small)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.centerY.equalToSuperview()
            }
            
        } else {
            
            iconImageView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }

            wordLable.snp.makeConstraints {
                $0.left.equalTo(iconImageView.snp.right).offset(Margin.small)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    func configurate(with model: HomeWordViewModel) {
        
        createUI(with: model)
        configureUI()
        
        logo.configure(with: .init(tintColor: Asset.Colors.readyWordBright.color))
        
        wordLable.text = model.word
        
        switch model.studyType {
            
        case .fire:
            wordLable.textColor = Asset.Colors.fireWordBright.color
            iconImageView.image = Asset.Images.wordMustReapetIcon.image
            iconImageView.tintColor = Asset.Colors.fireWordBright.color
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
            iconImageView.image = Asset.Images.newWordIcon.image
            iconImageView.tintColor = Asset.Colors.newWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Asset.Colors.newWord.color,
                    progressColor: Asset.Colors.newWord.color,
                    progress: 0.5
                )
            )
        case .waiting:
            wordLable.textColor = Asset.Colors.waitingWordBright.color
            iconImageView.image = Asset.Images.waitingWordIcon.image
            iconImageView.tintColor = Asset.Colors.waitingWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Asset.Colors.waitingWordPale.color,
                    progressColor: Asset.Colors.waitingWord.color,
                    progress: 0.5
                )
            )
        }
        
        rx.layoutSubviews
            .subscribe(onNext: { _ in
                self.layout(with: model)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeWordCell: ClassIdentifiable {}
