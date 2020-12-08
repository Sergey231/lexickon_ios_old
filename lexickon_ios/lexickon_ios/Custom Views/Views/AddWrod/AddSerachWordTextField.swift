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
        
        textView.pin
            .after(of: searchIconImageView)
            .marginLeft(Margin.regular)
            .vertically()
            .right(Margin.regular)
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
        layer.cornerRadius = 8
        backgroundColor = .white
        searchIconImageView.tintColor = .gray
        searchIconImageView.contentMode = .scaleAspectFit
        textView.isScrollEnabled = false
    }
}
