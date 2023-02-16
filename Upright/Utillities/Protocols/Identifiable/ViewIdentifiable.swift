import UIKit

protocol ViewIdentifiable: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ViewIdentifiable where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
