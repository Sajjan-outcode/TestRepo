//
//  UIView.swift
//

import UIKit

extension UIView {
    func noAutoResizingMaskConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loadNib<T: UIView>(_: T.Type) where T: ViewIdentifiable {
        Bundle.main.loadNibNamed(T.defaultReuseIdentifier, owner: self, options: nil)
    }
    
    func searchInViewAnchestors<ViewType: UIView>() -> ViewType? {
        if let matchingView = self.superview as? ViewType {
            return matchingView
        } else {
            return superview?.searchInViewAnchestors()
        }
    }
    
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    

    func addBorder(withWidth width: CGFloat, andColor color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func setShadow(with height: CGFloat,
                   and color: UIColor ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 3, height: height)
        layer.shadowOpacity = 0.8
    }
    
    func setRadiusWithShadow(_ radius: CGFloat? = nil,
                             color: UIColor = .gray) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    func setAllSideShadow(shadowShowSize: CGFloat = 1.0,
                          color: UIColor = UIColor.lightGray
                            .withAlphaComponent(0.8)) {
        let shadowSize: CGFloat = shadowShowSize
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func addCornerRadius(corners: UIRectCorner,
                         radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func round(corners: UIRectCorner,
               radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func rotate(angle: CGFloat, to frame: CGRect,
                withCompletion: @escaping () -> Void) {
        let radians = angle / 180.0 * CGFloat.pi
        
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = self.transform.rotated(by: radians)
            self.frame = frame
            self.layoutIfNeeded()
        }) { (_) in
            self.layoutSubviews()
            withCompletion()
        }
    }
    
    func topRoundCorner() {
        addCornerRadius(corners: [.topLeft, .topRight],
                        radius: 10)
    }
    
    func bottomRoundCorner(withRadius radius: CGFloat = 20.0) {
        addCornerRadius(corners: [.bottomLeft, .bottomRight],
                        radius: radius)
    }
    
//    static func getPageIndicatorImage(with color: UIColor) -> UIImage {
//        let view = UIView(frame: CGRect(origin: .zero,
//                                        size: CGSize(width: 10.0, height: 10.0)))
//        view.backgroundColor = color
//        view.makeCircular()
//        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
//        let image = renderer.image { _ in
//            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        }
//        return image
//    }
    
    func attachToTop(on view: UIView) {
        view.addSubview(self)
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
//    func attachBase(scrollView: UIScrollView,
//                    contentView: UIView,
//                    topView: UIView? = nil, constant: CGFloat = 0) {
//        self.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        scrollView.topAnchor.constraint(equalTo: topView.isNil
//                                        ? self.safeAreaLayoutGuide.topAnchor
//                                        : topView!.bottomAnchor, constant: constant)
//            .isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
//            .isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
//            .isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//            .isActive = true
//
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
//            .isActive = true
//        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
//            .isActive = true
//        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
//            .isActive = true
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
//            .isActive = true
//
//        contentView.widthAnchor
//            .constraint(equalTo: scrollView.widthAnchor)
//            .isActive = true
//    }
    
    static func getVerticalStackView(withPadding spacing: CGFloat = 0.0,
                                     withColor color: UIColor = .clear) -> UIStackView {
        let stackView = UIStackView()
        stackView.backgroundColor = color
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func getHorizontalStackView(withPadding spacing: CGFloat = 0.0,
                                       distribution: UIStackView.Distribution? =
                                       UIStackView.Distribution.fillProportionally) -> UIStackView {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = distribution ?? UIStackView.Distribution.fill
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func getScrollView(withBackground color: UIColor = .clear) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = color
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }
    
    static func getContentView(withBackground color: UIColor = .clear) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
//    static func getSeparatorView(with color: UIColor = Colors.separatorGrayColor,
//                                 height: CGFloat = 1.0) -> LineSeparatorView {
//        let view = LineSeparatorView()
//        view.separatorColor = color
//        view.heightAnchor.constraint(equalToConstant: height).isActive = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }
//
//    static func getRegularLabel(with title: String? = "",
//                                textcolor: UIColor = Colors.grayColor,
//                                alignment: NSTextAlignment = .left) -> UILabel {
//        let label = UILabel()
//        label.textColor = textcolor
//        label.text = title?.localized
//        label.textAlignment = alignment
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.font = Font(Font.FontType.installed(.proximaNovaRegular),
//                          size: Font.FontSize.custom(20.0)).instance
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//
//    static func getLabel(with title: String? = "",
//                         textcolor: UIColor = Colors.grayColor,
//                         alignment: NSTextAlignment = .left,
//                         font: UIFont = Font(Font.FontType.installed(.proximaNovaBold),
//                                             size: Font.FontSize.custom(12.0)).instance) -> UILabel {
//        let label = UILabel()
//        label.textColor = textcolor
//        label.text = title?.localized
//        label.textAlignment = alignment
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.font = font
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//
//    static func getSmallLabel(with title: String? = "",
//                              textcolor: UIColor = Colors.grayColor,
//                              alignment: NSTextAlignment = .left,
//                              font: UIFont = Font(Font.FontType.installed(.proximaNovaRegular),
//                                                  size: Font.FontSize.custom(12.0)).instance) -> UILabel {
//        let label = UILabel()
//        label.textColor = textcolor
//        label.text = title?.localized
//        label.textAlignment = alignment
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.font = font
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//
//}
//
//extension UIStackView {
//    func removeAllArrangedSubviews() {
//        arrangedSubviews.forEach {
//            self.removeArrangedSubview($0)
//            NSLayoutConstraint.deactivate($0.constraints)
//            $0.removeFromSuperview()
//        }
//    }
//}
//extension UIView {
//
//    // In order to create computed properties for extensions, we need a key to
//    // store and access the stored property
//    fileprivate struct AssociatedObjectKeys {
//        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
//    }
//
//    fileprivate typealias Action = (() -> Void)?
//
//    // Set our computed property type to a closure
//    fileprivate var tapGestureRecognizerAction: Action? {
//        get {
//            let tapGestureRecognizerActionInstance =
//            objc_getAssociatedObject(self,
//                                     &AssociatedObjectKeys.tapGestureRecognizer)
//            as? Action
//            return tapGestureRecognizerActionInstance
//        }
//        set {
//            if let newValue = newValue {
//                // Computed properties get stored as associated objects
//                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer,
//                                         newValue,
//                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//            }
//        }
//    }
//
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
//    public func addTapGestureRecognizer(action: (() -> Void)?) {
//        self.isUserInteractionEnabled = true
//        self.tapGestureRecognizerAction = action
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
//        self.addGestureRecognizer(tapGestureRecognizer)
//    }
//    
//    // Every time the user taps on the UIImageView, this function gets called,
//    // which triggers the closure we stored
//    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
//        if let action = self.tapGestureRecognizerAction {
//            action?()
//        } else {
//            print("no action")
//        }
//    }
    
}
