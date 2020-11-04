//
//  DisposableTableViewCell.swift
//  SpreadsheetApp
//
//  Created by Dmitriy Petrov on 09/10/2019.
//  Copyright © 2019 BytePace. All rights reserved.
//

import RxSwift
import UIKit

open class DisposableTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

