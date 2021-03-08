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
import RxExtensions
import SnapKit

public final class SwitchIconButton: UIView {
    
    public struct Input {
        
        public init(
            onIcon: UIImage,
            offIcon: UIImage,
            onColor: UIColor? = nil,
            offColor: UIColor? = nil,
            selected: Driver<Bool>? = nil
        ) {
            self.onIcon = onIcon
            self.offIcon = offIcon
            self.onColor = onColor
            self.offColor = offColor
            self.selected = selected
        }
        public let onIcon: UIImage
        public let offIcon: UIImage
        public let onColor: UIColor?
        public let offColor: UIColor?
        public let selected: Driver<Bool>?
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let iconImageView = UIImageView()
    
    private let onRelay = BehaviorRelay<Bool>(value: true)
    
    public var on: Driver<Bool> {
        onRelay.asDriver()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        iconImageView.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        button.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        
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
        
        onRelay
            .map { $0 ? input.onColor : input.offColor }
            .asDriver(onErrorDriveWith: .empty())
            .filter { $0 != nil }
            .drive(iconImageView.rx.tintColor)
            .disposed(by: disposeBag)
        
        input
            .selected?
            .drive(onRelay)
            .disposed(by: disposeBag)
    }
}
