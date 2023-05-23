//import UIKit
//
//struct ViewControllerUtility {
//
//    static func getTop(from window: UIWindow?) -> UIViewController? {
//        if let wrappedWindow = window, var topController = wrappedWindow.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            return topController
//        }
//        return nil
//    }
//
//}
//
//extension AppDelegate {
//
//    static func getCurrentWindow() -> UIWindow? {
//        // swiftlint:disable force_cast
//        return (UIApplication.shared.delegate as! AppDelegate).window
//        // swiftlint:enable force_cast
//    }
//
//    static func getDelegate() -> AppDelegate {
//        // swiftlint:disable force_cast
//        return UIApplication.shared.delegate as! AppDelegate
//        // swiftlint:enable force_cast
//    }
//
//}
