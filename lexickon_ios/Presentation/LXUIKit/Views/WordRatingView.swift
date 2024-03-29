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
    
    public struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let scaleImageView = UIImageView(image: Images.WordRating.scale.image)
    fileprivate let arrowImageView = UIImageView(image: Images.WordRating.arrow.image)
    
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
    
    public func configure(input: Input) -> Output {
        
        input.rating
            .drive(rx.rating)
            .disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        
        let didTap = tap.rx.event
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
        
        return Output(didTap: didTap)
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
