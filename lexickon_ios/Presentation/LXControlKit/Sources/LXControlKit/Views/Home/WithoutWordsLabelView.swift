//
//  WithoutWordsLabelView.swift
//  
//
//  Created by Sergey Borovikov on 06.06.2021.
//

import UIKit
import UIExtensions
import Assets
import SnapKit

public final class WithoutWordsLabelView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    fileprivate let infoLabel = UILabel()
    fileprivate let logo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = .clear
        
        infoLabel.setup {
            $0.text = "У вас пока нет слов\n  в вашем"
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = Colors.waitingWord.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.top.equalToSuperview()
                $0.height.equalTo(72)
            }
        }
        
        logo.setup {
            $0.image = Images.textLogo.image
            $0.tintColor = Colors.waitingWord.color
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(46)
                $0.top.equalTo(infoLabel.snp.bottom)
            }
        }
    }
}
