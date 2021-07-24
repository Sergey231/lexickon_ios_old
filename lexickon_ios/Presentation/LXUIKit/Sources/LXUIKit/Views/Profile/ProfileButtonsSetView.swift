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
        
    }
    
    public struct Output {
        
    }
    
    private let buttonsStackView = UIStackView()
    
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
        
        buttonsStackView.setup {
            addSubview($0)
        }
    }
    
    public func configure(input: Input) -> Output {
        
        Output()
    }
}
