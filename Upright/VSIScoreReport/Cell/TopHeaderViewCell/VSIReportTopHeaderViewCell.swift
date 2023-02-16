//
//  VSIReportTopHeaderViewCell.swift
//  Upright
//
//  Created by Sajjan on 16/02/2023.
//

import UIKit

class VSIReportTopHeaderViewCell : UITableViewHeaderFooterView {
    
    var viewModel: VSIReportViewModel!

    
    @IBOutlet weak private var patientNameLabel: UILabel!
    
    @IBOutlet weak private var patientEmailLabel: UILabel!
    
    @IBOutlet weak private var reportGenerateDateLabel: UILabel!
    
    @IBOutlet weak private var clinicNameLabel: UILabel!
    
    @IBOutlet weak private var clinicPhoneLabel: UILabel!
    @IBOutlet weak private var clinicAddressLabel: UILabel!
    
    @IBOutlet weak private var clinicEmailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showReportInfoView()
    }
    
    private func showReportInfoView() {
        let reportInfoModel = viewModel.getReportInfo()
        patientNameLabel.text = reportInfoModel.patientFirstName
        patientEmailLabel.text = reportInfoModel.patientEmail
        reportGenerateDateLabel.text = reportInfoModel.currentDate
        clinicNameLabel.text = reportInfoModel.clinicName
        clinicAddressLabel.text = reportInfoModel.clinicAddress
        clinicPhoneLabel.text = "n/a"
        clinicEmailLabel.text = reportInfoModel.clinicEmail
    }
    
    
}
