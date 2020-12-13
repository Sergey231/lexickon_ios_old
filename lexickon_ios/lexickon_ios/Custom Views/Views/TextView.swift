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
import SnapKit

final class TextView: UIView {
    
    struct Input {
        var font: UIFont = .systemRegular17
        var textColor: UIColor = Asset.Colors.baseText.color
    }
    
    struct Output {
        let size: Driver<CGSize>
    }
    
    private let disposeBag = DisposeBag()
    
    let textView = UITextView()
    
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
        
        textView.font = input.font
        textView.textColor = input.textColor
        
        let size = rx.size
            .take(1)
            .asDriver(onErrorDriveWith: .empty())
        
        let textFieldSize = Driver.merge(
            textView.rx.text.asDriver(onErrorDriveWith: .empty()).map { _ in () },
            size.asDriver(onErrorDriveWith: .empty()).map { _ in () }
        ) .map { [weak self] _ -> CGSize in
            let textFieldWidth = self!.frame.size.width
            let size = CGSize(width: textFieldWidth, height: .infinity)
            let estimatedSize = self?.textView.sizeThatFits(size)
            return CGSize(width: textFieldWidth, height: estimatedSize?.height ?? 0)
        }
        
        textFieldSize
            .drive(rx.size)
            .disposed(by: disposeBag)
        
        return Output(size: textFieldSize)
    }
}

extension Reactive where Base: TextView {
    var size: Binder<CGSize> {
        return Binder(base) { base, size in
            base.snp.makeConstraints {
                $0.size.equalTo(size)
            }
            base.textView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
