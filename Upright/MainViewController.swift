//
//  MainViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/23/22.
//
import SwiftUI
import UIKit

class MainViewController: UIViewController, ObservableObject {
    

    @IBOutlet weak var providerInfo: UILabel!
    @IBOutlet weak var providerdetails: UILabel!
    
    @IBOutlet weak var CurrentView: UIView!
    
    @IBAction func Home_View(_ sender: Any) {
        setView(currentView: homeViewController.view)
    }
    @IBAction func Patient_View(_ sender: Any) {
        setView(currentView: patientSearchViewController.view)
    }
    @IBAction func Scans_View(_ sender: Any) {
        setView(currentView: scanControllsViewController.view)
    }
    @IBAction func Surveys_View(_ sender: Any) {
        setView(currentView: supportViewController.view)
    }
    
    private static var displayingView:UIView!
    
    private let org: String = "organization"
    
    private let sqlStatment: String = " SELECT id, name, address, city, state, zip FROM organization WHERE id = '\(Organization.id ?? 1)'"
    
   
    private var scanControllsViewController: ScanControllsViewController!
    private var homeViewController: HomeViewController!
    private var patientSearchViewController: PatientSearchViewController!
    private var questionsViewController: QuestionsViewController!
    private var patientProfileViewController: PatientProfileViewController!
    private var supportViewController: SupportViewController!
    private var viewController: ViewController!
    private var bleManager: BLEManager!
    private let menuHieght: CGFloat = 156
    private let menuWidth: CGFloat = 923
    private let bodyHieght: CGFloat = 1054
    private let bodyWidth: CGFloat = 926
    
    
    
    private var screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bleManager =  BLEManager.init()
      
        let dataBase = db.init()
        defer {dataBase.connection?.close()}
        let cursor = dataBase.execute(text: sqlStatment)
        defer {dataBase.statment?.close()}
        defer {cursor.close()}
        do {
            for row in cursor {
                let columns = try row.get().columns
                let name = (try? columns[1].string()) ?? "UprightSpine"
                let address = (try? columns[2].string()) ?? "1471 W 1250 S"
                let city = (try? columns[3].string()) ?? "Orem"
                let state = (try? columns[4].string()) ?? "Utah"
                let zip = try columns[5].int()
                setProviderInfo(name: name, address: address, city: city, state: state, zip: zip)
            }
            } catch {
             print(error)
            }
        
         
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        self.scanControllsViewController = storyboard.instantiateViewController(withIdentifier: "ScanControllsViewController") as? ScanControllsViewController
        self.homeViewController =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.patientSearchViewController = storyboard.instantiateViewController(withIdentifier: "PatientSearchViewController") as? PatientSearchViewController
        self.questionsViewController = storyboard.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController
        self.patientProfileViewController = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        self.supportViewController = storyboard.instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController
       // viewController = ViewController()
       // viewController.setNewView(newView: homeViewController.view)
    
        if(ViewController.viewer == nil) {
        setView(currentView: homeViewController.view)
        }
      
    }
    
    func setProviderInfo(name: String, address: String, city: String, state: String, zip: Int){
        providerInfo?.text = "\(name)"
        providerdetails?.text = "\(address) \n \(city) \(state) \(zip)"
    }
    
    func setView(currentView: UIView){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewClass:Any
        
        if(ViewController.viewer != nil){
        ViewController.viewer.removeFromSuperview()
        }
        
//        switch view {
//        case "scan":
//            viewClass = ScanControllsViewController()
//        case "home":
//            viewClass = HomeViewController()
//        case "patientSearch":
//            viewClass = PatientSearchViewController()
//        case "questions":
//            viewClass = QuestionsViewController()
//        case "profile":
//            viewClass = PatientProfileViewController()
//        case "support":
//            viewClass = SupportViewController()
//        default:
//            viewClass = HomeViewController()
//        }
//        let setView = storyboard.instantiateViewController(withIdentifier: view)
        ViewController.viewer = currentView
        
        self.CurrentView.addSubview(currentView)
    }
    
    func settest(view:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewClass:Any
        
        if(ViewController.viewer != nil){
        ViewController.viewer.removeFromSuperview()
        }
        
        switch view {
        case "ScanControllsViewController":
            viewClass = ScanControllsViewController()
        case "HomeViewController":
            viewClass = HomeViewController()
        case "PatientSearchViewController":
            viewClass = PatientSearchViewController()
        case "QuestionsViewController":
            viewClass = QuestionsViewController()
        case "PatientProfileViewController":
            viewClass = PatientProfileViewController()
        case "SupportViewController":
            viewClass = SupportViewController()
        default:
            viewClass = HomeViewController()
        }
        
        let setView = storyboard.instantiateViewController(withIdentifier: view)
        ViewController.viewer = setView.view
        
        self.CurrentView.addSubview(setView.view)
    }
    
}
