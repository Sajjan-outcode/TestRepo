//
//  ViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 2/23/22.
//

import UIKit

var qScan: Bool = false

class LoginViewController: UIViewController {
    
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    @IBAction func QuickScan(_ sender: Any) {
        setDbConnections()
        if(self.defualts.integer(forKey: "orgId") != nil){
            Organization.id = self.defualts.integer(forKey: "orgId")
            qScan = true
            present(mainView!, animated: true, completion: nil)
        }else{
            
        }
        
        
    }
    
    private let defualts = UserDefaults.standard
    
    var mainView: BaseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password_field?.borderStyle = UITextField.BorderStyle.roundedRect
        userName?.borderStyle = UITextField.BorderStyle.roundedRect
        setUpBaseViewController()
        
        userName.text! = "doc"
        password_field.text! = "123"
       // autoLoginIfPossible()
        
       
    }
    
    private func autoLoginIfPossible() {
        qScan = false
        BaseViewController.firstLogin = true
        setDbConnections()
        let login = LoginView()
        login.getUserInfo(userName: userName.text!)
        if(login.validateUser(password: password_field.text!)){
            transitionToHome()
            setOrganizationValues()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    private func setUpBaseViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainView = storyboard.instantiateViewController(withIdentifier:"BaseViewController") as? BaseViewController
    }
    
    @IBAction func login(_ sender: Any) {
        qScan = false
        BaseViewController.firstLogin = true
        setDbConnections()
        let login = LoginView()
        login.getUserInfo(userName: userName.text!)
        if(login.validateUser(password: password_field.text!)){
            transitionToHome()
            setOrganizationValues()
        }
    }
    
    func transitionToHome(){
        ViewController.viewer = nil
        present(mainView!, animated: true, completion: nil)
    }
    
    func setOrganizationValues(){
        self.defualts.set(Organization.id, forKey: "orgId")
        self.defualts.set(Organization.name, forKey: "orgName")
        self.defualts.set(Organization.address, forKey: "orgAddress")
        self.defualts.set(Organization.city, forKey: "orgCity")
        self.defualts.set(Organization.state, forKey: "orgState")
        self.defualts.set(Organization.zip, forKey: "orgZip")
    }
    
    func setDbConnections(){
        db.host = "3.220.67.185"//"54.160.216.20" // test host
        db.dev = false
    }
}
