//
//  TextView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Utils

final class TextView: UIView {
    
    struct Input {
        
    }
    
    struct Output {
        let height: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    private let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubview(textView)
    }
    
    private func configureUI() {
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(input: Input) -> Output {
        
        let textFieldHeight = Driver.merge(
            textView.rx.text.asDriver(onErrorDriveWith: .empty()).map { _ in () },
            rx.layoutSubviews.take(1).asDriver(onErrorDriveWith: .empty()).map { _ in () }
        ) .map { [weak self] _ -> CGFloat in
            let textFieldWidth = self!.frame.size.width
            let size = CGSize(width: textFieldWidth, height: .infinity)
            let estimatedSize = self?.textView.sizeThatFits(size)
            print("😀: \(textFieldWidth)")
            print("😀😀: \(String(describing: estimatedSize?.height))")
            return estimatedSize?.height ?? 10
        }
        
        textFieldHeight
            .drive(onNext: {
                self.textView.pin
                    .horizontally()
                    .height($0)
            })
            .disposed(by: disposeBag)
        
        return Output(height: textFieldHeight)
    }
}
