//
//  VSIReportImageCollectionViewCell.swift
//  Upright
//
//  Created by Sajjan on 07/02/2023.
//

import UIKit

class VSIReportImageCollectionViewCel: UICollectionViewCell {
    
    @IBOutlet weak var collectionWapperView: UIView!
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var spineImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView(){
        collectionWapperView.layer.borderWidth = 0.5
        collectionWapperView.layer.borderColor = Colors.grayColor.cgColor
    }
    
}

