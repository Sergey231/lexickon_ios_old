//
//  TranslationResultCell.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 07.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils
import RxDataSources
import UIExtensions

public struct TranslationResultViewModel {
    public init(translation: String) {
        self.translation = translation
    }
    public let translation: String
}

extension TranslationResultViewModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.translation == rsh.translation
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(translation)
    }
}

extension TranslationResultViewModel: IdentifiableType {
    public var identity: String {
        return self.translation
    }
    public typealias Identity = String
}

public final class TranslationResultCell: DisposableTableViewCell {
    
    private let translationLable: UILabel = {
        let label = UILabel()
        label.font = .systemRegular17
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: TranslationResultViewModel) {
        contentView.addSubviews(
            translationLable
        )
        
        translationLable.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Margin.regular)
            $0.right.equalToSuperview().offset(-Margin.regular)
            $0.bottom.top.equalToSuperview()
        }
        
        translationLable.text = input.translation
    }
    
    public func configurate(with model: TranslationResultViewModel) {
        createUI(with: model)
    }
}

extension TranslationResultCell: ClassIdentifiable {}

