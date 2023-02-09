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
    
    
    
    func bindData(data: VSIReportViewModel){
        
        dateValue.text = data.dateValue
        statureValue.text = data.statureValue
        leanValue.text = data.leanValue
        sXfXValue.text = data.sXfXValue
        proportionCervicalValue.text = data.proportionCervicalValue
        proportionThoracicValue.text = data.proportionThoracicValue
        proportionLumbarValue.text = data.proportionLumbarValue
        normalityCervicalValue.text = data.normalityCervicalValue
        normalityThoracicValue.text = data.normalityThoracicValue
        normalityLumbarValue.text = data.normalityLumbarValue
        vsiScoreValue.text = data.vsiScoreValue
        
    }
    
}

