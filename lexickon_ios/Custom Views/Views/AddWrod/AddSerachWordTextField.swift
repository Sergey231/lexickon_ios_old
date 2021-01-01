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
    
    enum UIConstants {
        static let minHeight: CGFloat = 40
    }
    
    struct Output {
        let height: Driver<CGFloat>
        let text: ControlProperty<String?>
    }
    
    private let disposeBag = DisposeBag()
    
    private let textView = TextView()
    private var textViewHeight: CGFloat = 0
    
    private var searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.searchIcon.image)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: Text
    private var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
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
            $0.leading.equalToSuperview().offset(Margin.regular)
            $0.top.equalToSuperview().offset(Margin.small)
            $0.size.equalTo(Size.icon)
        }
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-Margin.regular)
            $0.left.equalTo(searchIconImageView.snp.right).offset(Margin.small)
        }
    }
    
    func configure() -> Output {
        
        let textViewHeight = textView.configure(input: .init())
            .estimatedHeight
            .map { $0 < UIConstants.minHeight ? UIConstants.minHeight : $0 }
        
        return Output(
            height: textViewHeight,
            text: textView.rx.text
        )
    }
}
