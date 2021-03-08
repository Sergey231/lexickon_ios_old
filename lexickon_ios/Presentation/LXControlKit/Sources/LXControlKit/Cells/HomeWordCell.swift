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
import LexickonApi

public struct HomeWordViewModel {
    
    public init(
        word: String,
        studyType: StudyType
    ) {
        self.word = word
        self.studyType = studyType
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

public final class HomeWordCell: DisposableTableViewCell, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let swipeContentView = UIView()
    private let wordLable = UILabel()
    private let progressView = WideWordProgressView()
    private lazy var iconImageView = UIImageView()
    private lazy var logo = Logo()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: HomeWordViewModel) {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        
        progressView.setup {
            $0.layer.cornerRadius = CornerRadius.big
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalToSuperview().offset(Margin.regular/2)
                $0.bottom.equalToSuperview().offset(-Margin.regular/2)
            }
        }
        
        if input.isReady {
            progressView.addSubview(logo)
            logo.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }

        } else {
            progressView.addSubview(iconImageView)
            iconImageView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }
        }
        
        wordLable.setup {
            $0.font = .systemRegular24
            contentView.addSubview($0)

            if input.isReady {
                wordLable.snp.makeConstraints {
                    $0.left.equalTo(logo.snp.right).offset(Margin.small)
                    $0.right.equalToSuperview().offset(-Margin.regular)
                    $0.centerY.equalToSuperview()
                }
            } else {
                wordLable.snp.makeConstraints {
                    $0.left.equalTo(iconImageView.snp.right).offset(Margin.small)
                    $0.right.equalToSuperview().offset(-Margin.regular)
                    $0.centerY.equalToSuperview()
                }
            }
        }
        
        scrollView.setup {
            $0.delegate = self
            $0.alwaysBounceHorizontal = true
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        swipeContentView.setup {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(self.contentView.snp.height)
                $0.width.greaterThanOrEqualTo(self.contentView.snp.width)
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configurate(with model: HomeWordViewModel) {
        
        createUI(with: model)
        
        logo.configure(with: .init(tintColor: Colors.readyWordBright.color))
        
        wordLable.text = model.word
        
        let contentOffsetX = scrollView.rx
            .didScroll
            .asDriver()
            .map { [unowned self] _ in self.scrollView.contentOffset.x }
            .filter { $0 >= 0 }
        
        contentOffsetX.drive(onNext: { [unowned self] offsetX in
            progressView.snp.updateConstraints {
                $0.right.equalToSuperview().offset(-(Margin.regular + offsetX))
            }
        })
        .disposed(by: disposeBag)
        
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
    }
}

extension HomeWordCell: ClassIdentifiable {}
