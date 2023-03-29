//
//  VSIReportFooterCell.swift
//  Upright
//
//  Created by Sajjan on 16/02/2023.
//

import UIKit

class VSIReportSubHeaderCell: BaseCustomNibloadableTableViewCell {
    
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
    
    var deltaModel: VSIReporDeltaCellModel! {
        didSet {
            dateValue.text =  deltaModel.date
            statureValue.text = deltaModel.statureValue
            leanValue.text = deltaModel.leanValue
            sXfXValue.text = deltaModel.sXfXValue
            proportionCervicalValue.text = deltaModel.proportionCervicalValue
            proportionThoracicValue.text = deltaModel.proportionThoracicValue
            proportionLumbarValue.text = deltaModel.proportionLumbarValue
            normalityCervicalValue.text = deltaModel.normalityCervicalValue
            normalityThoracicValue.text = deltaModel.normalityThoracicValue
            normalityLumbarValue.text = deltaModel.normalityLumbarValue
            vsiScoreValue.text = deltaModel.vsiScoreValue
            
        }
    }
    
    var deviationModel: VSIReportDeviationCellModel! {
        didSet {
            dateValue.text =  deviationModel.date
            statureValue.text = deviationModel.statureValue
            leanValue.text = deviationModel.leanValue
            sXfXValue.text = deviationModel.sXfXValue
            proportionCervicalValue.text = deviationModel.proportionCervicalValue
            proportionThoracicValue.text = deviationModel.proportionThoracicValue
            proportionLumbarValue.text = deviationModel.proportionLumbarValue
            normalityCervicalValue.text = deviationModel.normalityCervicalValue
            normalityThoracicValue.text = deviationModel.normalityThoracicValue
            normalityLumbarValue.text = deviationModel.normalityLumbarValue
            vsiScoreValue.text = deviationModel.vsiScoreValue
            setupView()
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateValue.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
    func setupView() {
        
       // dateValue.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        statureValue.textColor = Colors.grayColor
        leanValue.textColor = Colors.emergencyRed
        sXfXValue.textColor = Colors.emergencyRed
        proportionCervicalValue.textColor = Colors.emergencyRed
        proportionThoracicValue.textColor = Colors.emergencyRed
        proportionLumbarValue.textColor  = Colors.emergencyRed
        normalityCervicalValue.textColor = Colors.emergencyRed
        normalityThoracicValue.textColor = Colors.emergencyRed
        normalityLumbarValue.textColor   = Colors.emergencyRed
        vsiScoreValue.textColor   = Colors.emergencyRed
    }
    
    

}
   
