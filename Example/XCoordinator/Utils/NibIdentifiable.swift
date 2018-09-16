//
//  NibIdentifiable.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import UIKit

protocol NibIdentifiable {
    static var nibIdentifier: String { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
}

extension UIView: NibIdentifiable {
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: NibIdentifiable {
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension NibIdentifiable where Self: UIViewController {

    static func instantiateFromNib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }

}

extension NibIdentifiable where Self: UIView {

    static func instantiateFromNib() -> Self {
        guard let view = UINib(nibName: nibIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Couldn't find nib file for \(String(describing: Self.self))")
        }
        return view
    }

}

extension UITableView {

    func registerCell<T: UITableViewCell>(type: T.Type) {
        register(type.nib, forCellReuseIdentifier: String(describing: T.self))
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) {
        register(type.nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't find nib file for \(String(describing: T.self))")
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Couldn't find nib file for \(String(describing: T.self))")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) -> T {
        guard let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't find nib file for \(String(describing: T.self))")
        }
        return headerFooterView
    }

}

extension UICollectionView {

    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        register(type.nib, forCellWithReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Couldn't find nib file for \(String(describing: T.self))")
        }
        return cell
    }

}
