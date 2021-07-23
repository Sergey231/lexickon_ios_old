//
//  ProfileInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift

struct UserProfileEntity {
    
}

protocol ProfileInteractorProtocol {
    func logout() -> Single<Void>
    var user: UserEntity { get }
}
