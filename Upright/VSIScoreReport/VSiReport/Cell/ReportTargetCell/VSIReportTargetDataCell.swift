//
//  VSIReportTargetCell.swift
//  Upright
//
//  Created by Sajjan on 08/03/2023.
//

import UIKit

class VSIReportTargetDataCell: BaseCustomNibloadableTableViewCell {
    

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
        setUpView()
        addStaticValue()
    }

    private func setUpView() {
        dateValue.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        containerWrapperView.backgroundColor = Colors.fadeBlueColor
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

    }

    private func addStaticValue() {
        dateValue.text = "TARGET"
        statureValue.text = "n/a"
        leanValue.text = "0º"
        sXfXValue.text =  "100"
        proportionCervicalValue.text = "25%"
        proportionThoracicValue.text = "45%"
        proportionLumbarValue.text   = "30%"
        normalityCervicalValue.text  = "12%"
        normalityThoracicValue.text  = "12%"
        normalityLumbarValue.text    = "12%"
        vsiScoreValue.text           = "0"

    }

    
}
