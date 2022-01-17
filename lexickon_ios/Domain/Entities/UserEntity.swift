//
//  UserEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 23.07.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift

public struct UserEntity {
    
    public let name: String
    public let email: String
    
    public init(
        name: String,
        email: String
    ) {
        self.name = name
        self.email = email
    }
}
