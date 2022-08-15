//
//  ControllerTableViewCell.swift
//  Upright
//
//  Created by USS - Software Dev on 7/20/22.
//

import UIKit

class ControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var PatientName: UILabel!
    @IBOutlet weak var DOB: UILabel!
    
    func setCellLabels(name: String, dob: String){
        PatientName.text = name
        DOB.text = dob
    }
    

}
