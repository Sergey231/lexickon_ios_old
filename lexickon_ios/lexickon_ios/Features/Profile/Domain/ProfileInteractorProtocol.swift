//
//  ProfileInteractorProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift

protocol ProfileInteractorProtocol {
    
    func logout() -> Single<Void>
}
