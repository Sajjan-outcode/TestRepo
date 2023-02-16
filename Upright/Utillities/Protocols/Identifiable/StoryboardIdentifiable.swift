import UIKit

protocol StoryboardIdentifiable: ViewControllerIdentifiable {
    var name: String {get}
}

extension StoryboardIdentifiable {
    private func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.name, bundle: nil)
    }
    
    func viewController<T: UIViewController>(_: T.Type) -> T where T: ViewControllerIdentifiable {
        // swiftlint:disable force_cast
        return storyboard().instantiateViewController(withIdentifier: T.name) as! T
        // swiftlint:enable force_cast
    }
}
