//
//  BaseViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/23/22.
//
import SwiftUI
import UIKit

class BaseViewController: UIViewController {
    
    static var firstLogin: Bool = false
    static var childView:String!
     
    static var child: UIViewController!{
        willSet{
            prevChild = child
        }
    }
    static var prevChild: UIViewController!

    @IBOutlet weak var providerInfo: UILabel!
    @IBOutlet weak var providerdetails: UILabel!
    
    @IBOutlet weak var quikScanLoginView: UIImageView!
    @IBOutlet weak var CurrentView: UIView!
    
    @IBAction func Home_View(_ sender: Any) {
        displayContentController(content: homeViewController)
            
    }
    @IBAction func Patient_View(_ sender: Any) {
        displayContentController(content: patientSearchViewController)
       
    }
    @IBAction func Scans_View(_ sender: Any) {
        displayContentController(content: scanControllsViewController)
    }
    @IBAction func Surveys_View(_ sender: Any) {
        displayContentController(content: supportViewController)
    }
   
    @IBAction func loginButton(_ sender: Any) {
        if(bleManager.isConnected() == true) {
        bleManager.disconnect()
        }
        print(bleManager.isConnected())
    }
    
    private static var displayingView:UIView!
    
    private let org: String = "organization"
    
    private let sqlStatment: String = " SELECT id, name, address, city, state, zip FROM organization WHERE id = '\(Organization.id ?? 1)'"
    
    private var loginView: LoginViewController!
    private var scanControllsViewController: ScanControllsViewController!
    private var homeViewController: HomeViewController!
    private var patientSearchViewController: PatientSearchViewController!
    private var questionsViewController: QuestionsViewController!
    private var patientProfileViewController: PatientProfileViewController!
    private var supportViewController: SupportViewController!
    private var viewController: ViewController!
    private let menuHieght: CGFloat = 156
    private let menuWidth: CGFloat = 923
    private let bodyHieght: CGFloat = 1054
    private let bodyWidth: CGFloat = 926
    private let defualts = UserDefaults.standard
    
    @IBOutlet weak var qScanTxt: UILabel!
    @IBOutlet weak var qScanLoginB: UIButton!
    @IBOutlet weak var Home: UIButton!
    @IBOutlet weak var Patient: UIButton!
    @IBOutlet weak var Scans: UIButton!
    @IBOutlet weak var Support: UIButton!
    
    var timer = Timer()
    
    private var screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bleManager =  BLEManager.init()
        
//        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(userIsInactive), userInfo: nil, repeats: true)
//            let timerGesture = UITapGestureRecognizer(target: self, action: #selector(resetTimer))
//            self.view.isUserInteractionEnabled = true
//            self.view.addGestureRecognizer(timerGesture)
        
        if(Organization.id != nil && qScan == false){
        setProviderInfo(name: Organization.name!, address: Organization.address!, city: Organization.city!, state: Organization.state!, zip: Organization.zip!)
        }else{
            let name = defualts.string(forKey: "orgName")!
            let address = defualts.string(forKey: "orgAddress")!
            let city = defualts.string(forKey: "orgCity")!
            let state = defualts.string(forKey: "orgState")!
            let zip = defualts.string(forKey: "orgZip")!
            setProviderInfo(name: name, address: address, city: city, state: state, zip: zip)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        loginView = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController

        self.scanControllsViewController = storyboard.instantiateViewController(withIdentifier: "ScanControllsViewController") as? ScanControllsViewController
        self.homeViewController =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.patientSearchViewController = storyboard.instantiateViewController(withIdentifier: "PatientSearchViewController") as? PatientSearchViewController
        self.questionsViewController = storyboard.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController
        self.patientProfileViewController = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        self.supportViewController = storyboard.instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController

      
        //if(BaseViewController.child == nil || qScan == true) {
        if(BaseViewController.firstLogin){
            displayContentController(content: homeViewController)
            quikScanLoginView.isHidden = true
            qScanTxt.isHidden = true
            qScanLoginB.isHidden = true
            BaseViewController.firstLogin = false
            }
        else if(qScan == true) {
            Home.isEnabled = false
            Patient.isEnabled = false
            Scans.isEnabled = false
            Support.isEnabled = false
            quikScanLoginView.isHidden = false
            quikScanLoginView.isHidden = false
            qScanTxt.isHidden = false
            qScanLoginB.isHidden = false
            displayContentController(content: scanControllsViewController)
        }
        
      
    }
    
    
//    @objc func userIsInactive() {
//        // Alert user
//        let alert = UIAlertController(title: "You have been inactive for 5 minutes. We're going to log you off for security reasons.", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
//            self.present(self.loginView, animated: true, completion: nil)
//        }))
//        present(alert, animated: true)
//
//        timer.invalidate()
//     }
//
//    @objc func resetTimer() {
//        print("Reset")
//        timer.invalidate()
//        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(userIsInactive), userInfo: nil, repeats: true)
//     }
    
    func displayContentController(content: UIViewController) {
        if(BaseViewController.child != content){
            BaseViewController.child = content
            self.addChild(content)
            content.view.frame = CurrentView.bounds
            CurrentView.addSubview(content.view)
            
            if(BaseViewController.prevChild != nil){
                hideContentController(content: BaseViewController.prevChild)
            }
        }
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    func setProviderInfo(name: String, address: String, city: String, state: String, zip: String){
        providerInfo?.text = "\(name)"
        providerdetails?.text = "\(address) \n \(city) \(state) \(zip)"
    }
    
    func setView(currentView: UIView){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewClass:Any
        
        if(ViewController.viewer != nil){
        var test = ViewController.viewer!
        ViewController.viewer.removeFromSuperview()
    
        }
        
        ViewController.viewer = currentView
        
        self.CurrentView.addSubview(currentView)
    }
    
    
}


