//
//  PatientAttachmentCollectionViewCell.swift
//  Upright
//
//  Created by outcode  on 23/08/2023.
//

import UIKit
import SnapKit

class  PatientAttachmentCollectionViewCell: UICollectionViewCell {
 
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
     func setupView() {
        self.addSubview(imageView) 
         
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
