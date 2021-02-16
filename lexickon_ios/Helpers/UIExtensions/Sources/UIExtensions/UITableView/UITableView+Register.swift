//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 04.11.2020.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: ClassIdentifiable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseId)
    }

    func dequeueReusableCell<T: UITableViewCell>(
        withCellType type: T.Type = T.self
    ) -> T where T: ClassIdentifiable {
        guard
            let cell = dequeueReusableCell(withIdentifier: type.reuseId) as? T
        else {
            fatalError(dequeueError(withIdentifier: type.reuseId, type: self))
        }

        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(
        withCellType type: T.Type = T.self,
        forIndexPath indexPath: IndexPath
    ) -> T where T: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else { fatalError(dequeueError(withIdentifier: type.reuseId, type: self)) }

        return cell
    }
}

