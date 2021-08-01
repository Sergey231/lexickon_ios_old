//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 24.07.2021.
//

import RxSwift
import RxCocoa
import UIKit
import Assets
import SnapKit

public final class NotificationsView: UIView {
    
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        
    }
    
    private let topLineView = UIView()
    private let stackView = UIStackView()
    private let bottomLineView = UIView()
    private let fireWordsNotificaitonsView = SwitchMenuItemView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        topLineView.setup {
            $0.backgroundColor = Colors.pale.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(0.5)
                $0.top.equalToSuperview()
            }
        }
        
        bottomLineView.setup {
            $0.backgroundColor = Colors.pale.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(0.5)
                $0.bottom.equalToSuperview()
            }
        }
        
        stackView.setup {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.spacing = Margin.regular
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(topLineView.snp.bottom).offset(Margin.regular)
                $0.bottom.equalTo(bottomLineView.snp.top).offset(-Margin.regular)
            }
        }
        
        fireWordsNotificaitonsView.setup {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(48)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        _ = fireWordsNotificaitonsView.configure(
            input: SwitchMenuItemView.Input(
                icon: Images.Profile.fireNotificationIcon.image,
                on: .just(false),
                description: "Уведамления о горячих словах"
            )
        )
        
        return Output()
    }
}

