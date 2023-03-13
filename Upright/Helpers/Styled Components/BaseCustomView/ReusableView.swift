import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentififer: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentififer: String {
        return String(describing: self)
    }
}
