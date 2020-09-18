//
//  UserRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift

protocol UserRepositoryProtocol {
    
    func createUser(with credentions: UserCreateObject) -> Single<UserGetObject>
}
