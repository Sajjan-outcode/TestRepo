//
//  BaseViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/23/22.
//
import SwiftUI
import UIKit
import WebKit
import SnapKit

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
    
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()
    
    
    var timer = Timer()
    
    private var screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setUpWebView()
        
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
    
    
    func setUpWebView(){
        self.view.addSubview(webView)
        webView.snp.makeConstraints{make in
            make.right.top.bottom.left.equalToSuperview().inset(50)
        }
        callWixApi()
        
    }
    
    
    private func callWixApi() {
        guard let url =   WixOAuthUtilities.getUrl(with: WixConstants.appId, and: WixConstants.redirectURl) else {return}
        let request = webView.load(URLRequest(url: url))
    }
    
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


extension BaseViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = webView.url,
            WixOAuthUtilities.hasCallBackPrefix(url.absoluteString,
                                                redirectUrl: WixConstants.redirectURl),
            let code = WixOAuthUtilities.getAccessTokenAndState(from: url) {
            WixOAuthNetworkCaller.getTokenUrlReguest(with: code, clientId: WixConstants.appId, secretKey: WixConstants.appSecretKey, redirectUrl: WixConstants.redirectURl) { token, error in
                
            }
            self.webView.isHidden = true
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
}


