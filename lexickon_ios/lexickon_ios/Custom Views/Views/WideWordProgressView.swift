//
//  WideWordProgressView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 22.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class WideWordProgressView: UIView {
    
    struct Input {
        let bgColor: UIColor
        let progressColor: UIColor
        let progress: CGFloat
    }
    
    private let progressView = UIView()
    private let overlapView = UIView()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        addSubviews(
            progressView,
            overlapView
        )
        
        progressView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Margin.small)
            $0.bottom.equalToSuperview().offset(-Margin.small)
            $0.right.equalToSuperview().offset(-Margin.small)
            $0.left.equalToSuperview().offset(Margin.small)
        }
        
        overlapView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Margin.small)
            $0.bottom.equalToSuperview().offset(-Margin.small)
            $0.right.equalToSuperview().offset(-Margin.small)
            $0.left.equalToSuperview().offset(Margin.small)
        }
    }
    
    func configure(input: Input) {
        backgroundColor = input.bgColor
        overlapView.backgroundColor = input.bgColor
        progressView.backgroundColor = input.progressColor
        progressView.layer.cornerRadius = 12
        
        rx.layoutSubviews.take(1)
            .subscribe(onNext: {
                self.overlapView.snp.updateConstraints {
                    $0.left.equalToSuperview().offset((self.progressView.frame.maxX - 10) * input.progress)
                }
            })
            .disposed(by: disposeBag)
    }
}
