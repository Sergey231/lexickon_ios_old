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
        
    }
    
    public struct Output {
        
    }
    
    private let topLineView = UIView()
    private let notificationsStackView = UIStackView()
    private let bottomLineView = UIView()
    
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
        
        topLineView.setup {
            $0.backgroundColor = .lightGray
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(1)
                $0.top.equalToSuperview()
            }
        }
        
        bottomLineView.setup {
            $0.backgroundColor = .lightGray
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(1)
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        Output()
    }
}

