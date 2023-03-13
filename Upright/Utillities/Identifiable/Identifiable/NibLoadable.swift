import UIKit

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self,
                                              options: nil).first as? UIView
            else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func loadNibView<T: UIView>(_: T.Type, withOwner owner: Any) -> UIView where T: ViewIdentifiable {
        let nib = UINib(nibName: T.defaultReuseIdentifier, bundle: Bundle.main)
        // swiftlint:disable force_cast
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        // swiftlint:enable force_cast
        return nibView
    }
    
}
