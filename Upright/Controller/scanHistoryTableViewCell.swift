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
    
    func setScanHistory(ScanDate: String, ScanTime: String){
        self.scanDate.text = ScanDate
        self.scanTime.text = ScanTime
    }

}
