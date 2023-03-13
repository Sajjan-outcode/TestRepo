import UIKit

protocol ViewControllerIdentifiable { }

extension ViewControllerIdentifiable where Self: UIViewController {
    
    static var name: String {
        return String(describing: self)
    }
    
}
