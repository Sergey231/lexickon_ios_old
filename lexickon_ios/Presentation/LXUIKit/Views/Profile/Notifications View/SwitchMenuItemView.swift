//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 01.08.2021.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

public final class SwitchMenuItemView: UIView {
    
    public struct Input {
        let icon: UIImage
        let on: Driver<Bool>
        let description: String
        
        public init(
            icon: UIImage,
            on: Driver<Bool>,
            description: String
        ) {
            self.icon = icon
            self.on = on
            self.description = description
        }
    }
    
    public struct Output {
        let on: Driver<Bool>
    }
    
    private let iconImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let onSwitch = UISwitch()
    
    private let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        snp.makeConstraints {
            $0.height.equalTo(250)
        }
        
        iconImageView.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.size.equalTo(48)
                $0.left.equalToSuperview().offset(Margin.big)
            }
        }
        
        onSwitch.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-Margin.big)
                $0.centerY.equalToSuperview()
            }
        }
        
        descriptionLabel.setup {
            $0.textColor = Colors.baseText.color
            $0.font = .regular14
            $0.numberOfLines = 0
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(iconImageView.snp.right).offset(Margin.regular)
                $0.right.equalTo(onSwitch.snp.left).offset(-Margin.regular)
                $0.top.bottom.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        iconImageView.image = input.icon
        descriptionLabel.text = input.description
        
        input.on
            .drive(onSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        return Output(
            on: onSwitch.rx.isOn.asDriver()
        )
    }
}

