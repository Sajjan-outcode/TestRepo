import UIKit
// import SVPullToRefresh

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: ViewIdentifiable {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: ViewIdentifiable, T: NibLoadable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: ViewIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identified: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func registerHeader<T: UITableViewHeaderFooterView>(_: T.Type) where T: ViewIdentifiable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerHeader<T: UITableViewHeaderFooterView>(_: T.Type) where T: ViewIdentifiable, T: NibLoadable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: T.nibName)
    }

    func dequeueReusableHeader<T: UITableViewHeaderFooterView>() -> T where T: ViewIdentifiable {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identified: \(T.defaultReuseIdentifier)")
        }
        return header
    }
    
//    func updateSVPullTORefreshColor(to color: UIColor) {
//        pullToRefreshView.textColor = color
//        pullToRefreshView.arrowColor = color
//        pullToRefreshView.tintColor = color
//    }

}

extension UIScrollView {

//    func updateSVPullToRefreshView(hasInfiniteScrolling: Bool = true) {
//        pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
//        pullToRefreshView.arrowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        pullToRefreshView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        if hasInfiniteScrolling {
//            infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
//        }
//    }
}
