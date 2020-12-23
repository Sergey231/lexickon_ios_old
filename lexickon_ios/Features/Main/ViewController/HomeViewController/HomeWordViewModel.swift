//
//  HomeWordViewModel.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxDataSources

struct HomeWordViewModel {
    let word: String
}

extension HomeWordViewModel: Hashable {
    static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.word == rsh.word
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

extension HomeWordViewModel: IdentifiableType {
    var identity: String {
        return self.word
    }
    typealias Identity = String
}
