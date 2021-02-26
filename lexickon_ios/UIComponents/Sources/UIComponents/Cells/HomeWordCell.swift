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
import RxExtensions
import UIExtensions
import Assets

public struct HomeWordViewModel {
    
    public init(
        word: String,
        studyType: StudyType
    ) {
        self.word = word
        self.studyType = studyType
    }
    
    public enum StudyType {
        case fire
        case ready
        case new
        case waiting
    }
    
    public var isReady: Bool { self.studyType == .ready }
    
    public let word: String
    public let studyType: StudyType
}

extension HomeWordViewModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.word == rsh.word
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

extension HomeWordViewModel: IdentifiableType {
    public var identity: String {
        return self.word
    }
    public typealias Identity = String
}

public final class HomeWordCell: DisposableTableViewCell {
    
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
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    public func configurate(with model: HomeWordViewModel) {
        
        createUI(with: model)
        configureUI()
        
        logo.configure(with: .init(tintColor: Colors.readyWordBright.color))
        
        wordLable.text = model.word
        
        switch model.studyType {
            
        case .fire:
            wordLable.textColor = Colors.fireWordBright.color
            iconImageView.image = Images.wordMustReapetIcon.image
            iconImageView.tintColor = Colors.fireWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.fireWordPale.color,
                    progressColor: Colors.fireWord.color,
                    progress: 0.5
                )
            )
        case .ready:
            wordLable.textColor = Colors.readyWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.readyWordPale.color,
                    progressColor: Colors.readyWord.color,
                    progress: 0.5
                )
            )
        case .new:
            wordLable.textColor = Colors.newWordBright.color
            iconImageView.image = Images.newWordIcon.image
            iconImageView.tintColor = Colors.newWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.newWord.color,
                    progressColor: Colors.newWord.color,
                    progress: 0.5
                )
            )
        case .waiting:
            wordLable.textColor = Colors.waitingWordBright.color
            iconImageView.image = Images.waitingWordIcon.image
            iconImageView.tintColor = Colors.waitingWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.waitingWordPale.color,
                    progressColor: Colors.waitingWord.color,
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
