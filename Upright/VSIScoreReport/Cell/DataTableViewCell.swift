//
//  DataTableViewCell.swift
//  Upright
//
//  Created by Sajjan on 07/02/2023.
//

import UIKit

class DataTableViewCell : UITableViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitalState()
    }
    
    private func setInitalState() {
        dateValue.text = ""
        statureValue.text = ""
        leanValue.text =  ""
        sXfXValue.text = ""
        proportionCervicalValue.text = ""
        proportionThoracicValue.text = ""
        proportionLumbarValue.text = ""
        normalityCervicalValue.text = ""
        normalityThoracicValue.text = ""
        normalityLumbarValue.text = ""
        vsiScoreValue.text = ""
        
        
        dateValue.textColor = Colors.white
        statureValue.textColor = Colors.white
        leanValue.textColor = Colors.white
        sXfXValue.textColor = Colors.white
        proportionCervicalValue.textColor = Colors.white
        proportionThoracicValue.textColor = Colors.white
        proportionLumbarValue.textColor = Colors.white
        normalityCervicalValue.textColor = Colors.white
        normalityThoracicValue.textColor = Colors.white
        normalityLumbarValue.textColor = Colors.white
        vsiScoreValue.textColor = Colors.white
        containerWrapperView.backgroundColor = Colors.fadeBlueColor
        
    }
    
    func staticTargetData() {
        
        dateValue.text = "Target"
        statureValue.text = "n/a"
        leanValue.text =  "0"+"º"
        sXfXValue.text = "100"
        proportionCervicalValue.text = "25%"
        proportionThoracicValue.text = "45%"
        proportionLumbarValue.text = "30%"
        normalityCervicalValue.text = "12%"
        normalityThoracicValue.text = "12%"
        normalityLumbarValue.text = "12%"
        vsiScoreValue.text = "0"
        setupTargetCellView()
    }
    
    
    private func setupTargetCellView() {
        dateValue.textColor = Colors.white
        statureValue.textColor = Colors.white
        leanValue.textColor = Colors.white
        sXfXValue.textColor = Colors.white
        proportionCervicalValue.textColor = Colors.white
        proportionThoracicValue.textColor = Colors.white
        proportionLumbarValue.textColor = Colors.white
        normalityCervicalValue.textColor = Colors.white
        normalityThoracicValue.textColor = Colors.white
        normalityLumbarValue.textColor = Colors.white
        vsiScoreValue.textColor = Colors.white
        containerWrapperView.backgroundColor = Colors.fadeBlueColor
   
    }
    
}

