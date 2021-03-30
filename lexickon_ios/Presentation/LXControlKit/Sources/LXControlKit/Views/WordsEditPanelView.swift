//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 30.03.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets

public final class WordEditPanelView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(
            learnCount: Driver<UInt>,
            resetCount: Driver<UInt>,
            deleteCount: Driver<UInt>
        ) {
            self.learnCount = learnCount
            self.resetCount = resetCount
            self.deleteCount = deleteCount
        }
        let learnCount: Driver<UInt>
        let resetCount: Driver<UInt>
        let deleteCount: Driver<UInt>
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
//        backgroundColor = .clear
        
    }
    
    public func configure(input: Input) {
        
       
    }
}
