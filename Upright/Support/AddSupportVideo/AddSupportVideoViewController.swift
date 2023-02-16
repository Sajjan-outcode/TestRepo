//
//  AddSupportVideoViewController.swift
//  Upright
//
//  Created by Sajjan on 05/02/2023.
//

import UIKit

protocol AddSupportVideoViewControllerDelegate: AnyObject {
    func didAddSupportVideoInDatabase(with  title : String?, description: String?, link: String?)
}

class AddSupportVideoViewController : UIViewController {
    
    weak var delegate: AddSupportVideoViewControllerDelegate?
    var showAlert: UIAlertController?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextViewField: UITextView!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    private func setUpView() {
        
        self.descriptionTextViewField.layer.borderWidth = 0.5
        self.descriptionTextViewField.layer.borderColor = Colors.blackColor.cgColor
        self.descriptionTextViewField.tintColor = Colors.grayTextColor
        
        self.titleTextField.layer.borderWidth = 0.5
        self.titleTextField.layer.borderColor = Colors.blackColor.cgColor
        
        self.linkTextField.layer.borderWidth = 0.5
        self.linkTextField.layer.borderColor = Colors.blackColor.cgColor
        
    }
    
    private func checkTextFieldValidity() {
        if titleTextField.text == "" || linkTextField.text == "" || descriptionTextViewField.text == "" {
           showAttentionAlert(title: "Alert", message: "Please fill all the form")
        } else {
            saveAddedVideo()
        }
    }
    
    func showAttentionAlert(title: String , message: String) {
        
        showAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.showAlert?.dismiss(animated: true)
         })
        showAlert?.addAction(ok)
        self.present(showAlert!, animated: true, completion: nil)
    }
    
    private func saveAddedVideo() {
        guard let vTitle = self.titleTextField.text ,
               let vDescription = self.descriptionTextViewField.text,
               let vlink = self.linkTextField.text else {return}
          self.delegate?.didAddSupportVideoInDatabase(with: vTitle, description:vDescription, link: vlink )
         self.dismiss(animated: false)
    }
    
    @IBAction func addVideoBtn(_ sender: Any) {
       
        checkTextFieldValidity()
        
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
