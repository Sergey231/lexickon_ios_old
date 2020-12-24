//
//  ProfileMainScreen.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Resolver

final class ProfileMainScreenPresenter: PresenterType {
    
    @Injected var interactor: ProfileInteractorProtocol
    
    struct Input {
        let didTapLogOut: Signal<Void>
    }
    
    struct Output {
        let didLogout: Signal<Void>
    }
    
    func configure(input: Input) -> Output {
        
        let didLogout = input.didTapLogOut
            .flatMap {
                self.interactor.logout()
                    .asSignal(onErrorSignalWith: .empty())
            }
        
        return Output(
            didLogout: didLogout
        )
    }
}
