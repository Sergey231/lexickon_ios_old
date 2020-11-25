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
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.pin.all(Margin.small)
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            progressView,
            overlapView
        )
    }
    
    private func configureUI() {
        progressView.layer.cornerRadius = 12
    }
    
    func configure(input: Input) {
        backgroundColor = input.bgColor
        overlapView.backgroundColor = input.bgColor
        progressView.backgroundColor = input.progressColor
        
        rx.layoutSubviews.take(1)
            .subscribe(onNext: {
                self.overlapView.pin
                    .vertically(Margin.small)
                    .right(Margin.small)
                    .left((self.progressView.frame.maxX - 10) * input.progress)
            })
            .disposed(by: disposeBag)
    }
}

