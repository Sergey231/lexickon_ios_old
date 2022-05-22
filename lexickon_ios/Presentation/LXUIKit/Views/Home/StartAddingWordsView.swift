//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 06.06.2021.
//
import UIKit
import UIExtensions
import SnapKit
import RxSwift
import RxCocoa

public final class StartAddingWordsView: UIView {
    
    public struct Output {
        public let selectWordsButtonTap: Signal<Void>
        public let authoAddingWordsButtonTap: Signal<Void>
        public let manualAddingWordsButtonTap: Signal<Void>
    }
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    fileprivate let selectWordsButton = UIButton()
    fileprivate let autoAddingWordsButton = UIButton()
    fileprivate let manualAddingWordsButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = .clear
        
        manualAddingWordsButton.setup {
            $0.setTitle(Str.homeManualAddingWordsButtonTitle, for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.right.equalToSuperview().offset(-Margin.mid)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.height.equalTo(Size.button.height)
            }
        }
        
        autoAddingWordsButton.setup {
            $0.setTitle(Str.homeAutoaddingButtonTitle, for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalTo(manualAddingWordsButton.snp.top).offset(-Margin.mid)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.height.equalTo(Size.button.height)
            }
        }
        
        selectWordsButton.setup {
            $0.setTitle(Str.homeSelecteWordsButtonTitle, for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalTo(autoAddingWordsButton.snp.top).offset(-Margin.mid)
                $0.left.equalToSuperview().offset(Margin.mid)
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.height.equalTo(Size.button.height)
                $0.top.equalToSuperview().offset(Margin.mid)
            }
        }
    }
    
    public func configure() -> Output {
        
        manualAddingWordsButton.setRoundedBorderedStyle(
            bgColor: Colors.mainBG.color,
            borderColor: Colors.mainBG.color
        )
        
        autoAddingWordsButton.setRoundedBorderedStyle(
            bgColor: Colors.mainBG.color,
            borderColor: Colors.mainBG.color
        )
        
        selectWordsButton.setRoundedBorderedStyle(
            bgColor: Colors.mainBG.color,
            borderColor: Colors.mainBG.color
        )
        
        return Output(
            selectWordsButtonTap: selectWordsButton.rx.tap.asSignal(),
            authoAddingWordsButtonTap: autoAddingWordsButton.rx.tap.asSignal(),
            manualAddingWordsButtonTap: manualAddingWordsButton.rx.tap.asSignal()
        )
    }
}
