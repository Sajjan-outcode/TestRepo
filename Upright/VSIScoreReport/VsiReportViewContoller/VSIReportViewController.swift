//
//  VSIReportViewController.swift
//  Upright
//
//  Created by Sajjan on 06/02/2023.
//

import UIKit

class VSIReportViewController : UIViewController {
    
    var viewModel: VSIReportViewModel!
    private var spineImage = UIImageView()
    private var scanPicData = [UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak private var patientName: UILabel!
    @IBOutlet weak private var reportGenerateDate: UILabel!
    @IBOutlet weak private var patientEmail: UILabel!
    
    @IBOutlet weak private var clinicName: UILabel!
    @IBOutlet weak private var clinicPhone: UILabel!
    @IBOutlet weak private var clinicAddress: UILabel!
    @IBOutlet weak private var clinicEmail: UILabel!
    
    @IBOutlet weak private var patientInfoView: UIView!
    @IBOutlet weak private var dateInfoView: UIView!
    @IBOutlet weak private var clinicalINfoView: UIView!
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showReportInfoView()
        setUpTableHeaderView()
    }
    
    private func setupView() {
        patientInfoView.layer.borderWidth = 0.5
        patientInfoView.layer.borderColor = Colors.blackColor.cgColor
        
        dateInfoView.layer.borderWidth = 0.5
        dateInfoView.layer.borderColor = Colors.blackColor.cgColor
        
        clinicalINfoView.layer.borderWidth = 0.5
        clinicalINfoView.layer.borderColor = Colors.blackColor.cgColor
    }
    
    private func showReportInfoView() {
        let reportInfoModel = viewModel.getReportInfo()
        patientName.text = reportInfoModel.patientFirstName
        patientEmail.text = reportInfoModel.patientEmail
        reportGenerateDate.text = reportInfoModel.currentDate
        clinicName.text = reportInfoModel.clinicName
        clinicAddress.text = reportInfoModel.clinicAddress
        clinicPhone.text = "n/a"
        clinicEmail.text = reportInfoModel.clinicEmail
    }
    
    func setUpTableHeaderView() {
        
        let headerNibName = UINib(nibName: "VSIReportHeaderView", bundle: nil)
        self.tableView.register(headerNibName, forHeaderFooterViewReuseIdentifier: "VSIReportHeaderView")
        
    }
    
}

extension VSIReportViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.patientScanVSICellModel.count
        case 1:
            return 1
        default:
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            cell.dataModel = viewModel.patientScanVSICellModel[indexPath.row]
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            // delta value fill
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            // cell fill in deviations
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "VSIReportHeaderView") as! VSIReportHeaderView
            
            return headerView
        case 1: return nil
        default:
            let header = UIView()
            header.backgroundColor = UIColor.yellow
            return header
        }
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 84
        case 1: return 0
        default: return 20
        }
    }
}

extension VSIReportViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.patientScanslist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VSIReportImageCollectionViewCel", for: indexPath) as? VSIReportImageCollectionViewCel else { return UICollectionViewCell() }
        cell.spineImage.image = viewModel.getImageForScan(at: indexPath.row)
        return cell
    }
    
}

extension VSIReportViewController: VSIReportViewModelDelegate {
    
    func refreshScanImageList() {
        collectionView.reloadData()
    }
    
}
