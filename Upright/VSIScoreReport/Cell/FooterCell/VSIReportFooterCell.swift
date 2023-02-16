//
//  VSIReportFooterCell.swift
//  Upright
//
//  Created by Sajjan on 16/02/2023.
//

import UIKit


class VSIReportFooterCell: UITableViewHeaderFooterView {
    
    
    var dataModel: VSIReportCellModel! {
        didSet {
            dateValue.text =  dataModel.date
            statureValue.text = dataModel.statureValue
            leanValue.text = dataModel.leanValue
            sXfXValue.text = dataModel.sXfXValue
            proportionCervicalValue.text = dataModel.proportionCervicalValue
            proportionThoracicValue.text = dataModel.proportionThoracicValue
            proportionLumbarValue.text = dataModel.proportionLumbarValue
            normalityCervicalValue.text = dataModel.normalityCervicalValue
            normalityThoracicValue.text = dataModel.normalityThoracicValue
            normalityLumbarValue.text = dataModel.normalityLumbarValue
            vsiScoreValue.text = dataModel.vsiScoreValue
            
        }
    }
    
    @IBOutlet weak private var dateValue: UILabel!
    @IBOutlet weak private var statureValue: UILabel!
    @IBOutlet weak private var leanValue: UILabel!
    @IBOutlet weak private var sXfXValue: UILabel!
    @IBOutlet weak private var proportionCervicalValue: UILabel!
    @IBOutlet weak private var proportionThoracicValue: UILabel!
    @IBOutlet weak private var proportionLumbarValue: UILabel!
    @IBOutlet weak private var normalityCervicalValue: UILabel!
    @IBOutlet weak private var normalityThoracicValue: UILabel!
    @IBOutlet weak private var normalityLumbarValue: UILabel!
    @IBOutlet weak private var vsiScoreValue: UILabel!
    @IBOutlet weak private var containerWrapperView: UIView!
    
    
    
    
    
}
