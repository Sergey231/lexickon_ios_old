//
//  UserEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 23.07.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift

public struct UserEntity {
    
    public let name: Observable<String>
    public let email: Observable<String>
    
    public init(
        name: Observable<String>,
        email: Observable<String>
    ) {
        self.name = name
        self.email = email
    }
}
