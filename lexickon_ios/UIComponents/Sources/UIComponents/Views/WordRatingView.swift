//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 14.02.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets

public final class WordRatingView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(
            rating: Driver<CGFloat>
        ) {
            self.rating = rating
        }
        let rating: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    private let scaleImageView = UIImageView(image: Asset.Images.WordRating.scale.image)
    fileprivate let arrowImageView = UIImageView(image: Asset.Images.WordRating.arrow.image)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = .clear
        alpha = 0
        
        scaleImageView.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        arrowImageView.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        
        input.rating
            .drive(rx.rating)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: WordRatingView {
    var rating: Binder<CGFloat> {
        Binder(base) { base, rating in
            UIView.animate(withDuration: 0.6) {
                base.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.6) {
                    base.arrowImageView.transform = CGAffineTransform(
                        rotationAngle: CGFloat.pi * rating
                    )
                }
            }
        }
    }
}
