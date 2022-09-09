//
//  scanHistoryTableViewCell.swift
//  Upright
//
//  Created by USS - Software Dev on 8/4/22.
//

import UIKit

class scanHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var scanDate: UILabel!
    @IBOutlet weak var scanTime: UILabel!
    @IBOutlet weak var scanId: UILabel!
    @IBOutlet weak var scanPatientName: UILabel!
    
    func setScanHistory(ScanDate: String, ScanTime: String, ScanId: Int, ScanPatientName: String){
        self.scanDate.text = ScanDate
        self.scanTime.text = ScanTime
        self.scanId.text = String(ScanId)
        self.scanPatientName.text = ScanPatientName
    }

}
