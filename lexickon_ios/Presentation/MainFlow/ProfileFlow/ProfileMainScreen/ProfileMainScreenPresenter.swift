//
//  ProfileMainScreen.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import Resolver

final class ProfileMainScreenPresenter {
    
    @Injected var interactor: ProfileInteractorProtocol
    
    struct Input {
        let didTapLogOut: Signal<Void>
    }
    
    struct Output {
        let didLogout: Signal<Void>
        let name: Driver<String>
        let email: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        
        let didLogout = input.didTapLogOut
            .flatMap { [unowned self] in
                self.interactor.logout()
                    .asSignal(onErrorSignalWith: .empty())
            }
        
        let name = interactor.user.name
            .asDriver(onErrorJustReturn: "")
        
        let email = interactor.user.email
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            didLogout: didLogout,
            name: name,
            email: email
        )
    }
}
