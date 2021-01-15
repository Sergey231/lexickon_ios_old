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
import Assets

final class AddWordButtonView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.searchIcon.image)
        imageView.alpha = 0
        imageView.tintColor = .white
        return imageView
    }()
    private let addIconImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.addIcon.image)
        imageView.tintColor = .white
        return imageView
    }()
    
    // public for Animator
    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 28
        view.backgroundColor = Asset.Colors.mainBG.color
        view.setShadow()
//        view.startFlayingAnimation()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.center.equalToSuperview()
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.size.equalTo(Size.icon)
            $0.center.equalToSuperview()
        }
        
        addIconImageView.snp.makeConstraints {
            $0.size.equalTo(Size.icon)
            $0.center.equalToSuperview()
        }
    }
    
    var didTap: Signal<Void> {
        button.rx.tap
            .map {()}
            .asSignal(onErrorSignalWith: .empty())
    }
}

