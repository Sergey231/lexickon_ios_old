//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 04.11.2020.
//

import UIKit

extension UICollectionView {
    func register<C: UICollectionViewCell>(cellType: C.Type) where C: ClassIdentifiable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseId)
    }

    func dequeueReusableCell<C: UICollectionViewCell>(withCellType type: C.Type = C.self, forIndexPath indexPath: IndexPath) -> C where C: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseId, for: indexPath) as? C else { fatalError(dequeueError(withIdentifier: type.reuseId, type: self)) }

        return cell
    }

    func dequeueReusableSupplementaryView<C: UICollectionReusableView>(withViewType type: C.Type = C.self, ofKind kind: String, forIndexPath indexPath: IndexPath) -> C where C: ClassIdentifiable {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.reuseId, for: indexPath) as? C else { fatalError(dequeueError(withIdentifier: type.reuseId, type: self)) }

        return view
    }
}

