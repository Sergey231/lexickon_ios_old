//
//  UserRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

struct UserRegistrationCredentions {
    let name: String
    let email: String
    let password: String
}

protocol UserRepositoryProtocol {
    
    func createUser(with credentions: UserRegistrationCredentions)
    func getUser()
}
