//
//  ImageViewExtension.swift
//  Upright
//
//  Created by Sajjan on 08/02/2023.
//

import UIKit
extension UIImageView {
    
    func loadFrom(URLAddress: String) {
            guard let url = URL(string: URLAddress) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let imageData = try? Data(contentsOf: url) {
                    if let loadedImage = UIImage(data: imageData) {
                            self?.image = loadedImage
                    }
                }
            }
        }
}
