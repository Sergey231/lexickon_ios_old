//
//  IconButton.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 18.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import SnapKit

final class SwitchIconButton: UIView {
    
    struct Input {
        let onIcon: UIImage
        let offIcon: UIImage
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let onRelay = BehaviorRelay<Bool>(value: true)
    
    var on: Driver<Bool> {
        onRelay.asDriver()
    }
    
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
    }
    
    func configure(input: Input) {
        button.rx.tap
            .withLatestFrom(onRelay.asObservable())
            .map { !$0 }
            .bind(to: onRelay)
            .disposed(by: disposeBag)
        
        onRelay
            .map { $0 ? input.onIcon : input.offIcon }
            .asDriver(onErrorDriveWith: .empty())
            .drive(iconImageView.rx.imageWithAnimation)
            .disposed(by: disposeBag)
    }
}
