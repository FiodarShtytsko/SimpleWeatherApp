//
//  UITableView+.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import UIKit

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

protocol NibLoadable {
    static var nibName: String { get }
}

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadable, T: Identifiable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Identifiable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: Identifiable {}

extension Identifiable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: NibLoadable {}

extension NibLoadable where Self: UITableViewCell {
    static var nibName: String {
        return String(describing: self)
    }
}
