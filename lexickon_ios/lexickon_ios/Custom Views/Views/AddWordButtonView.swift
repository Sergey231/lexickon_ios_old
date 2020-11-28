//
//  AddWordButtonView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class AddWordButton: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let circleView = UIView()
    private let searchIconImageView = UIImageView(image: Asset.Images.searchIcon.image)
    private let addIconImageView = UIImageView(image: Asset.Images.addIcon.image)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.pin.all()
        
        circleView.pin
            .size(56)
            .center()
        
        searchIconImageView.pin
            .size(24)
            .center()
        
        addIconImageView.pin
            .size(24)
            .center()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            circleView,
            button
        )
        circleView.addSubviews(
            searchIconImageView,
            addIconImageView
        )
    }
    
    private func configureUI() {
        
        circleView.layer.cornerRadius = 28
        circleView.backgroundColor = Asset.Colors.mainBG.color
        circleView.setShadow()
        circleView.startFlayingAnimation()
        
        searchIconImageView.alpha = 0
        searchIconImageView.tintColor = .white
        addIconImageView.tintColor = .white
    }
    
    var didTap: Signal<Void> {
        button.rx.tap
            .map {()}
            .asSignal(onErrorSignalWith: .empty())
    }
}

