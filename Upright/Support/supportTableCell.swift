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
    
    
    func setLabel(label:String?){
        guard let titleLable = label else {return}
        youTubeLabel.text =  titleLable
    }
    
    func setVideo(url: URL?){
      guard let vUrl = url else {return}
            youTubeVideo.loadRequest(URLRequest(url: vUrl))
        
    }
    
    func setDescription(description: String?){
        guard let vDescription = description else {return}
        youTubeDescription.text = vDescription
    }
    
    
}
