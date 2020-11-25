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

final class SwitchIconButton: UIView {
    
    struct Input {
        let onIcon: UIImage
        let offIcon: UIImage
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let iconImageView = UIImageView()
    private let onRelay = BehaviorRelay<Bool>(value: true)
    
    var on: Driver<Bool> {
        onRelay.asDriver()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.pin.all()
        button.pin.all()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            iconImageView,
            button
        )
    }
    
    private func configureUI() {
        iconImageView.contentMode = .scaleAspectFit
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
