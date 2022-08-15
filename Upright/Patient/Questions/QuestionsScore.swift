//
//  QuestionsScore.swift
//  Upright
//
//  Created by USS - Software Dev on 6/10/22.
//

import Foundation
import UIKit

struct QuestionsScore {
    
     let score: Int!
     let time_stamp: String!
    
    init(score: Int, time_stamp: String){
        self.score = score
        self.time_stamp = time_stamp
    }

}
