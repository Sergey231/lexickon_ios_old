//
//  AuthorizationRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift

protocol LoginRepositoryProtocol {
    
    func login(with tokin: UserTockenGetObject) -> Single<Void>
}
