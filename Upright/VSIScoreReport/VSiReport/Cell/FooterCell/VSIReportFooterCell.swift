//
//  VSIReportFooterCell.swift
//  Upright
//
//  Created by Sajjan on 16/02/2023.
//

import UIKit


class VSIReportFooterCell: BaseCustomNibLoadableView {
    
    @IBOutlet var contentView: UIView!
    var viewModel: VSIReportViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    @IBOutlet weak private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "ReportFooterCell", bundle: nil), forCellWithReuseIdentifier: "VSIReportImageCollectionViewCel")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func commonInit() {
        loadNib(VSIReportFooterCell.self)
        update(contentView)
    }
}

extension VSIReportFooterCell: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.patientScanslist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VSIReportImageCollectionViewCel", for: indexPath) as? VSIReportImageCollectionViewCel else {
            return UICollectionViewCell()
        }
        cell.spineImage.image = viewModel.getImageForScan(at: indexPath.row)
        return cell
    }
    
}
extension VSIReportFooterCell: VSIReportViewModelDelegate {
    
    func refreshScanImageList() {
        collectionView.reloadData()
    }
}
