//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 31.01.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets

public final class PaginationProgressView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(animateActivity: Driver<Bool>) {
            self.animateActivity = animateActivity
        }
        let animateActivity: Driver<Bool>
    }
    
    private let disposeBag = DisposeBag()
    public let activityView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = .white
        layer.cornerRadius = CornerRadius.big
        snp.makeConstraints {
            $0.height.equalTo(0)
        }
        
        activityView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        input.animateActivity
            .skip(2)
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
    }
}


private extension Reactive where Base: PaginationProgressView {
    var isLoading: Binder<Bool> {
        Binder(base) { base, isLoading in
            UIView.animate(withDuration: 0.1) {
                base.snp.updateConstraints {
                    $0.height.equalTo(isLoading ? 54 : 0)
                }
                base.alpha = isLoading ? 1 : 0
                if isLoading {
                    base.activityView.startAnimating()
                } else {
                    base.activityView.stopAnimating()
                }
                base.superview?.layoutIfNeeded()
            }
        }
    }
}

