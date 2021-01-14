//
//  Rx+MapToVoid.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift

public extension ObservableType {

    func mapToVoid() -> Observable<Void> { mapTo(()) }
    func mapTo<T>(_ value: T) -> Observable<T> { map { _ in value } }
}

public extension SharedSequence {

    func mapToVoid() -> SharedSequence<SharingStrategy, Void> { mapTo(()) }
    func mapTo<T>(_ value: T) -> SharedSequence<SharingStrategy, T> { map { _ in value } }
}
