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

public final class ProfileButtonsSetView: UIView {
    
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        public let logoutDidTap: Signal<Void>
    }
    
    private let stackView = UIStackView()
    private let supportProjectButton = UIButton()
    private let writeToDeveloperButton = UIButton()
    private let showHelpButton = UIButton()
    private let logoutButton = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        stackView.setup {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.spacing = Margin.regular
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(Size.button.width)
                $0.top.equalToSuperview().offset(Margin.mid)
                $0.bottom.equalToSuperview().offset(-Margin.mid)
            }
        }
        
        [supportProjectButton,
         writeToDeveloperButton,
         showHelpButton,
         logoutButton].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(Size.button)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        supportProjectButton.setRoundedBorderedStyle(
            bgColor: Colors.gold.color,
            borderColor: Colors.gold.color,
            titleColor: .white
        )
        
        writeToDeveloperButton.setRoundedBorderedStyle(
            bgColor: .white,
            borderColor: Colors.mainBG.color,
            titleColor: Colors.mainBG.color
        )
        
        showHelpButton.setRoundedBorderedStyle(
            bgColor: .white,
            borderColor: Colors.mainBG.color,
            titleColor: Colors.mainBG.color
        )
        
        logoutButton.setRoundedBorderedStyle(
            bgColor: .white,
            borderColor: Colors.mainBG.color,
            titleColor: Colors.mainBG.color
        )
        
        let didTapLogout = logoutButton.rx.tap
            .asSignal()
        
        return Output(logoutDidTap: didTapLogout)
    }
}
