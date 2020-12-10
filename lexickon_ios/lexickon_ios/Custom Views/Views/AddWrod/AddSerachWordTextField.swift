//
//  AddSerachWordTextField.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class AddSearchWordTextField: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let textView = UITextView()
    private let searchIconImageView = UIImageView(image: Asset.Images.searchIcon.image)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchIconImageView.pin
            .left(Margin.regular)
            .vCenter()
            .size(Sizes.icon)
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            searchIconImageView,
            textView
        )
    }
    
    private func configureUI() {
        
        _ = rx.layoutSubviews.take(1)
            .subscribe(onNext: {
                self.textView.pin
                    .after(of: self.searchIconImageView)
                    .marginLeft(Margin.regular)
                    .vertically()
                    .right(Margin.regular)
            })
        
        layer.cornerRadius = 8
        backgroundColor = .white
        searchIconImageView.tintColor = .gray
        searchIconImageView.contentMode = .scaleAspectFit
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure() {
        textView.rx.text
            .subscribe(onNext: { [weak self] _ in
                let textFieldWidth = self!.frame.size.width
                    - (Margin.regular
                    + Sizes.icon.width
                    + Margin.regular
                    + Margin.regular)
                let size = CGSize(width: textFieldWidth, height: .infinity)
                let estimatedSize = self?.textView.sizeThatFits(size)
                print("😀: \(textFieldWidth)")
                print("😀😀: \(estimatedSize?.height)")
                self?.textView.pin
                    .after(of: self!.searchIconImageView)
                    .marginLeft(Margin.regular)
                    .height(estimatedSize!.height)
                    .right(Margin.regular)
            })
            .disposed(by: disposeBag)
    }
}
