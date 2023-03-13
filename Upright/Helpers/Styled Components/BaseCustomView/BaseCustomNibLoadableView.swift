import UIKit

class BaseCustomNibLoadableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {}
    
    func update(_ contentView: UIView) {
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

extension BaseCustomNibLoadableView: ViewIdentifiable, NibLoadableView {}
