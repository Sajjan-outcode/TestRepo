//
//  DropShadow.swift
//  Upright
//
//  Created by USS - Software Dev on 3/18/22.
//

import UIKit

extension UIView {
    
    @IBInspectable var shadowOffset: CGSize{
          get{
              return self.layer.shadowOffset
          }
          set{
              self.layer.shadowOffset = newValue
          }
      }

      @IBInspectable var shadowColor: UIColor{
          get{
              return UIColor(cgColor: self.layer.shadowColor!)
          }
          set{
              self.layer.shadowColor = newValue.cgColor
          }
      }

      @IBInspectable var shadowRadius: CGFloat{
          get{
              return self.layer.shadowRadius
          }
          set{
              self.layer.shadowRadius = newValue
          }
      }
    
//    @IBInspectable var clipsToBounds: UIView{
//        get{
//            return clipsToBounds
//        }set{
//            clipsToBounds = newValue
//        }
//    }

      @IBInspectable var shadowOpacity: Float{
          get{
              return self.layer.shadowOpacity
          }
          set{
              self.layer.shadowOpacity = newValue
          }
      }
    
  }
