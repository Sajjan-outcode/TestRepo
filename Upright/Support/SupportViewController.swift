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
    var addSupportVideoController: AddSupportVideoViewController!
    weak private var delegate: AddSupportVideoViewControllerDelegate!
    
    @IBAction func MessageSupportButton(_ sender: Any) {
        if let url = URL(string: "http://www.uprightspine.com/contact"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func FAQButton(_ sender: Any) {
        if let url = URL(string: "http://www.uprightspine.com/help-center"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func addSupportVideo(_ sender: Any) {
           initAddVideoVideoController()
  
    }
    
    
    var supportVideos: [SupportVideo] = [] {
        didSet {
            SupportVideosWrapper(videos: supportVideos).save()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportVideos = SupportVideosWrapper.getVideos()
        setUpTableView()
      initAddVideoVideoController()
        self.delegate = self
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 225
        
        DatabaseManager.shared.getSupportVideos { [weak self] videos in
            guard let strongSelf = self else { return }
            strongSelf.supportVideos = videos
            strongSelf.tableView.reloadData()
        }
    }
    func initAddVideoVideoController() {
        let storyboard  = UIStoryboard(name: "AddSuportVideoViewController", bundle: nil)
        addSupportVideoController = storyboard.instantiateViewController(withIdentifier: "AddSupportVideoViewController") as? AddSupportVideoViewController
        if let presentationController = addSupportVideoController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
            }
            
            self.present(addSupportVideoController, animated: true)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func showDeleteAlert(forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "",
                                      message: "Are you sure you want to delete?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DatabaseManager.shared
                .deleteSupportVideos(video: self.supportVideos[indexPath.row]) { [weak self] (success, error) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.supportVideos.remove(at: indexPath.row)
                        strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        strongSelf.showErrorAlert(error: error)
                    }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.showDeleteAlert(forRowAt: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "deleteRed")
        deleteAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    
    func addNewVideo(title : String?, description: String?, link: String?) {
        guard let vTitle = title,
              let vDescription = description,
              let vLink = link else {return}
        let supportVideo = SupportVideo(id: UUID().uuidString, title: vTitle, description: vDescription, link: vLink)
        DatabaseManager.shared.addNewSupportVideo(video: supportVideo) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.supportVideos.append(supportVideo)
                strongSelf.tableView.reloadData()
            } else {
                strongSelf.showErrorAlert(error: error)
            }
        }
    }
    
}

extension SupportViewController: AddSupportVideoViewControllerDelegate {
    func didAddSupportVideoInDatabase(with title: String?, description: String?, link: String?) {
        self.addNewVideo(title: title, description: description, link: link)
    }
    
    
}
