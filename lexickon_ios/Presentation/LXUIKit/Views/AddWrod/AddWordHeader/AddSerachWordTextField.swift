//
//  AddSerachWordTextField.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import SnapKit

public final class AddSearchWordTextField: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public enum UIConstants {
        static let minHeight: CGFloat = 40
    }
    
    public struct Output {
        let height: Driver<CGFloat>
        let text: ControlProperty<String?>
    }
    
    private let disposeBag = DisposeBag()
    
    private let textView = TextView()
    private var textViewHeight: CGFloat = 0
    
    private var searchIconImageView = UIImageView(image: Images.searchIcon.image)
    
    //MARK: Text
    private var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        searchIconImageView.setup {
            $0.tintColor = .gray
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Margin.regular)
                $0.top.equalToSuperview().offset(Margin.small)
                $0.size.equalTo(Size.icon)
            }
        }
        
        textView.setup {
            $0.becomeFirstResponder()
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.left.equalTo(searchIconImageView.snp.right).offset(Margin.small)
            }
        }
    }
    
    public func configure() -> Output {
        
        layer.cornerRadius = 8
        backgroundColor = .white
        
        let textViewHeight = textView.configure(input: .init())
            .estimatedHeight
            .map { $0 < UIConstants.minHeight ? UIConstants.minHeight : $0 }
        
        return Output(
            height: textViewHeight,
            text: textView.rx.text
        )
    }
}
