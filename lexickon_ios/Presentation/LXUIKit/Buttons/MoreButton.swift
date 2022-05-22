//
//  MoreButton.swift
//  
//
//  Created by Sergey Borovikov on 17.06.2021.
//

import UIKit
import UIExtensions
import SnapKit
import RxCocoa
import RxSwift

public final class MoreButton: UIButton {
    
    private struct UIConstants {
        static let dotSize: CGFloat = 4
    }
    
    private let desposeBag = DisposeBag()
    
    fileprivate let topDotView = UIView()
    fileprivate let midDotView = UIView()
    fileprivate let bottomDotView = UIView()
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        self.createUI()
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        snp.makeConstraints {
            $0.size.equalTo(Size.icon)
        }
        
        midDotView.setup {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = UIConstants.dotSize/2
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.dotSize)
                $0.center.equalToSuperview()
            }
        }
        
        topDotView.setup {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = UIConstants.dotSize/2
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.dotSize)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(midDotView.snp.top).offset(-2)
            }
        }
        
        bottomDotView.setup {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = UIConstants.dotSize/2
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.dotSize)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(midDotView.snp.bottom).offset(2)
            }
        }
    }
    
    private func configure() {
        
    }
}

private extension Reactive where Base: MoreButton {
    
}
