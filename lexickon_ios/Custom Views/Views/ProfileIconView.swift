//
//  IconButtonView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import RxExtensions

final class ProfileIconView: UIView {
    
    struct Input {
        var icon: UIImage?
    }
    
    struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
            iconImageView,
            button
        )
        
        iconImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rx.size.take(1)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.layer.cornerRadius = self.frame.size.height/2
            })
            .disposed(by: disposeBag)
    }
    
    func configure(input: Input) -> Output {
        iconImageView.image = input.icon
        return Output(didTap: button.rx.tap.asSignal())
    }
}

