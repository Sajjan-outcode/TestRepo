//
//  View.swift
//  Upright
//
//  Created by Sajjan on 22/02/2023.
//

import UIKit
import SnapKit

open class View: UIView {
    
    convenience public init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
    }
    
    convenience public init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        localInit()
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        localInit()
        makeUI()
    }
    
    public func localInit() {
        
    }
    
    open func makeUI() {
        self.layer.masksToBounds = true
        updateUI()
    }
    
    
    open func updateUI() {
        setNeedsDisplay()
    }
    
    public func getCenter() -> CGPoint {
        return convert(center, from: superview)
    }
}

extension UIView {
    
    public var inset: CGFloat {
        return 12
    }
    
    public func setPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        self.setContentHuggingPriority(priority, for: axis)
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
}

