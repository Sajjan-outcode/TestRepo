//
//  QuestionsViewCell.swift
//  Upright
//
//  Created by USS - Software Dev on 3/11/22.
//

import UIKit

class QuestionsViewCell: UITableViewCell {

    @IBOutlet weak var answer_1: UILabel!
   
    
    func setAnswer(answer: Int){
        answer_1.text = String(answer)
    }

}
