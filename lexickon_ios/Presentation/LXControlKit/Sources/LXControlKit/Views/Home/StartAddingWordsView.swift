//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 06.06.2021.
//
import UIKit
import UIExtensions
import Assets
import SnapKit

public final class StartAddingWordsView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    fileprivate let selectWordsButton = UIButton()
    fileprivate let authoAddingWordsButton = UIButton()
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
        
        selectWordsButton.setup {
            
        }
        
        authoAddingWordsButton.setup {
            
        }
        
        manualAddingWordsButton.setup {
            
        }
    }
}
