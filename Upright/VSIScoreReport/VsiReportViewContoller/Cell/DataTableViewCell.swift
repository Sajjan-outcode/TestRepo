//
//  DataTableViewCell.swift
//  Upright
//
//  Created by Sajjan on 07/02/2023.
//

import UIKit

class DataTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var dateValue: UILabel!
    
    @IBOutlet weak var statureValue: UILabel!
    
    @IBOutlet weak var leanValue: UILabel!
    
    @IBOutlet weak var sXfXValue: UILabel!
    
    @IBOutlet weak var proportionCervicalValue: UILabel!
    
    @IBOutlet weak var proportionThoracicValue: UILabel!
    
    @IBOutlet weak var proportionLumbarValue: UILabel!
    
    @IBOutlet weak var normalityCervicalValue: UILabel!
    
    @IBOutlet weak var normalityThoracicValue: UILabel!
    
    @IBOutlet weak var normalityLumbarValue: UILabel!
    
    @IBOutlet weak var vsiScoreValue: UILabel!
    
    
    func bindData(data: PatientScan){
        
        dateValue.text = data.pic_date
        statureValue.text = "\(data.height ?? 0.0)"
        leanValue.text = "\(data.lean ?? 0.0)"
        sXfXValue.text = data.time_stamp
        proportionCervicalValue.text = "\(data.prop_C ?? 0)"
        proportionThoracicValue.text = "\(data.prop_T ?? 0)"
        proportionLumbarValue.text =   "\(data.prop_L ?? 0)"
        normalityCervicalValue.text =  "\(data.dl_C ?? 0.0)"
        normalityThoracicValue.text = "\(data.dl_T ?? 0.0)"
        normalityLumbarValue.text =  "\(data.dl_L ?? 0.0)"
        vsiScoreValue.text = data.first_name
        
    }
    
    
    
    
    
}
