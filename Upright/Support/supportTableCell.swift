//
//  supportTableCell.swift
//  Upright
//
//  Created by USS - Software Dev on 7/12/22.
//

import Foundation
import UIKit


class youTubeViewCell: UITableViewCell {
    
    @IBOutlet weak var youTubeLabel: UILabel!
    
    @IBOutlet weak var youTubeVideo: UIWebView!
    
    @IBOutlet weak var youTubeDescription: UILabel!
    
    
    func setLabel(label:String){
        youTubeLabel.text =  label
    }
    
    func setVideo(url: URL){
        youTubeVideo.loadRequest(URLRequest(url: url))
    }
    
    func setDescription(description: String){
        youTubeDescription.text = description
    }
    
    
}
