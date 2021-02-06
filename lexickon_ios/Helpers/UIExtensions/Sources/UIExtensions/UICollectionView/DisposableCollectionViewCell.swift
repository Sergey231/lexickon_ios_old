//
//  DisposableCollectionViewCell.swift
//  FoodApp
//
//  Created by Dmitriy Petrov on 21/11/2019.
//  Copyright © 2019 BytePace. All rights reserved.
//

import RxSwift
import UIKit

open class DisposableCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
