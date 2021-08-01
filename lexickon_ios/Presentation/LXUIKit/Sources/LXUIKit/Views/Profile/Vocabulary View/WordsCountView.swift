//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 26.07.2021.
//

import RxSwift
import RxCocoa
import UIKit
import Assets
import SnapKit

public final class WordsCountView: UIView {
    
    public struct Input {
        let icon: UIImage
        let count: UInt
        let description: String
    }
    
    public struct Output {
        
    }
    
    private let iconImageView = UIImageView()
    private let countLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
                $0.centerX.equalToSuperview().offset(-Margin.huge)
            }
        }
        
        countLabel.setup {
            $0.textColor = Colors.baseText.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(iconImageView.snp.right).offset(Margin.regular)
                $0.top.equalTo(iconImageView.snp.top).offset(2)
                $0.right.equalToSuperview()
            }
        }
        
        descriptionLabel.setup {
            $0.textColor = Colors.baseText.color
            $0.font = .regular12
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(iconImageView.snp.right).offset(Margin.regular)
                $0.top.equalTo(countLabel.snp.bottom)
                $0.right.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        iconImageView.image = input.icon
        countLabel.text = String(input.count)
        descriptionLabel.text = input.description
        
        return Output()
    }
}
