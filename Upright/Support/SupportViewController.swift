//
//  SupportViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 5/6/22.
//

import UIKit


class SupportViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var faqLink: UILabel!
    @IBOutlet weak var spportLink: LinkUILabel!
    
    @IBAction func MessageSupportButton(_ sender: Any) {
        if let url = NSURL(string: "http://www.uprightspine.com/contact"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    @IBAction func FAQButton(_ sender: Any) {
        if let url = NSURL(string: "http://www.uprightspine.com/help-center"){
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    var supportVideos: [Support] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createSupportArray()
      //  createHyperLink()
      //  createSupportLink()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 225
        
    }
    
    func createHyperLink(){
        let path = ""
        let text = faqLink.text ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: path, in: text, as: "Click here")
        let font = faqLink.font
        let textColor = faqLink.textColor
        faqLink.attributedText = attributedString
        faqLink.font = font
        faqLink.textColor = textColor
        
    }
    
    func createSupportLink(){
        let path = ""
        let text = spportLink.text ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: path, in: text, as: "Click here")
        let font = spportLink.font
        let textColor = spportLink.textColor
        spportLink.attributedText = attributedString
        spportLink.font = font
        spportLink.textColor = textColor
    }
    
    func createSupportArray(){
        
        let v1 = Support(title: "Back & Neck Symptom Control", description: "Patients learn how to manage symptoms safely and quickly at home.", link: "w97Ix5kRukc")
        let v2 = Support(title: "Isometrics Training", description: "Patients learn isometric exercises to stabalize and reset joints, rebuild tissue, and reduce pain.", link: "x1wMWtBVM6s")
        let v3 = Support(title: "Safe Positions", description: "Patients learn safe body positions, and techniques for changing positions while healing from back or neck injuries.", link: "G2ipLdBwZn8")
        let v4 = Support(title: "Spine Goals", description: "Patients learn the how to meet and keep the Uprightly Program goals to maintain a spine-healthy life.", link: "5MV5gsHbOgY")
        let v5 = Support(title: "Spine Rules", description: "Patients learn the rules they must adopt and follow if they wish to keep symptoms at bay.", link: "z8WQTS5Yavo")
        let v6 = Support(title: "UpLifter Exercise", description: "Patients learn how to mobilize joints, hydrate discs, and renew their spine with the UpLifter Exercise Machine.", link: "i5DLaJVNrzM")
        let v7 = Support(title: "Spine Consequences", description: "Patients learn what mechanical conditions they may suffer from if they ignore symptoms or the spine rules.", link: "hV9KWvRQ9ok")
        let v8 = Support(title: "Spine Rebuilding Principles", description: "Patients learn the principles for rebuilding and maintaining a stronger and healthier spine.", link: "9y1soUqeOsw")
        let v9 = Support(title: "Spine Protection", description: "Patients learn how to protect their renewed spine health to help avoid re-injury and the return of symptoms.", link: "4e8I6OU8EVQ")
        
        supportVideos.append(v1)
        supportVideos.append(v2)
        supportVideos.append(v3)
        supportVideos.append(v4)
        supportVideos.append(v5)
        supportVideos.append(v6)
        supportVideos.append(v7)
        supportVideos.append(v8)
        supportVideos.append(v9)
        
    }
    
    func getVideo(videoCode:String) -> URL{
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        return url!
    }
   
}

extension SupportViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = supportVideos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! youTubeViewCell
        
        cell.setLabel(label: video.title)
        cell.setVideo(url: getVideo(videoCode: video.link))
        cell.setDescription(description: video.description)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


