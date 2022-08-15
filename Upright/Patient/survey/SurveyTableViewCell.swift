//
//  SurveyTableViewCell.swift
//  Upright
//
//  Created by USS - Software Dev on 6/10/22.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {

 
    @IBOutlet weak var surveys: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSurvey(survey: QuestionsScore) {
        surveys.text = survey.time_stamp
    }
}
