//
//  ViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 2/23/22.
//

import UIKit
// import PostgresClientKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    //var userPassword : String?
    //var rows : [PostgresValue]?

    override func viewDidLoad() {
        super.viewDidLoad()
        password_field?.borderStyle = UITextField.BorderStyle.roundedRect
        userName?.borderStyle = UITextField.BorderStyle.roundedRect
      
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func login(_ sender: Any) {
        let login = LoginView()
        login.getUserInfo(userName: userName.text!)
        if(login.validateUser(password: password_field.text!)){
            transitionToHome()
        }
    }
    
    func transitionToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyboard.instantiateViewController(withIdentifier:"MainViewController")
        present(mainView, animated: true, completion: nil)
    
    }
    
}

