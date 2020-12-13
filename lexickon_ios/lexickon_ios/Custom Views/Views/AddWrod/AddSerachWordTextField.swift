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
import SnapKit

final class AddSearchWordTextField: UIView {
    
    struct Output {
        let height: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    private let textView = TextView()
    
    private var searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.searchIcon.image)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        addSubviews(
            searchIconImageView,
            textView
        )
    }
    
    private func configureUI() {
        
        layer.cornerRadius = 8
        backgroundColor = .white
        
        searchIconImageView.snp.makeConstraints {
            $0.left.equalTo(Margin.regular)
            $0.top.equalTo(Margin.small)
            $0.size.equalTo(Sizes.icon)
        }
    }
    
    func configure() -> Output {
        
        let textViewSize = textView.configure(input: .init())
            .size
        
        textViewSize.debug("🧦").drive()
        
        return Output(height: textViewSize.map { $0.height } )
    }
}
