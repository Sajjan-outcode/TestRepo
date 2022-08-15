//
//  GradientView.swift
//  Upright
//
//  Created by USS - Software Dev on 2/23/22.
//

import UIKit
@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var FirstColor : UIColor = .clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var ThirdColor : UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.shouldRasterize = true
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor, ThirdColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        layer.endPoint = CGPoint(x: 0, y: 2) // Bottom right corner.
        
    }
    
}
