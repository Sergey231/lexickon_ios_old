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
// import Utils
import SnapKit
import Assets

public final class TextView: UITextView {
    
    public struct Input {
        var font: UIFont = .regular17
        var textColor: UIColor = Colors.baseText.color
    }
    
    public struct Output {
        let estimatedHeight: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0.5, alpha: 0.85)
        label.backgroundColor = .clear
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureView()
    }

    private func configureView() {
        configureUI()
    }
    
    private func configureUI() {
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func configure(input: Input) -> Output {
        
        font = input.font
        textColor = input.textColor
        
        let size = rx.size
            .take(1)
            .asDriver(onErrorDriveWith: .empty())
        
        let textWasUpdated = rx.text.asDriver(onErrorDriveWith: .empty()).map { _ in () }
        
        let estimatedHeight = textWasUpdated
            .withLatestFrom(size) { [weak self] _, _size -> CGFloat in
                let size = CGSize(width: _size.width, height: .infinity)
                let estimatedSize = self?.sizeThatFits(size)
                return estimatedSize?.height ?? 0
            }
        
        return Output(estimatedHeight: estimatedHeight)
    }
}
