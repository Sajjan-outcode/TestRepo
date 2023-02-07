//
//  VSIReportViewController.swift
//  Upright
//
//  Created by Sajjan on 06/02/2023.
//

import UIKit

class VSIReportViewController : UIViewController {
    
    var patientScanslist: [PatientScan] = []
    
    @IBOutlet weak var patientInfoView: UIView!
    
    @IBOutlet weak var dateInfoView: UIView!
    @IBOutlet weak var clinicalINfoView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView() {
        
        self.patientInfoView.layer.borderWidth = 0.5
        self.patientInfoView.layer.borderColor = Colors.blackColor.cgColor
        
        self.dateInfoView.layer.borderWidth = 0.5
        self.dateInfoView.layer.borderColor = Colors.blackColor.cgColor
        
        self.clinicalINfoView.layer.borderWidth = 0.5
        self.clinicalINfoView.layer.borderColor = Colors.blackColor.cgColor
        
    }
    
    
}

extension VSIReportViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return patientScanslist.count
        default:
            return patientScanslist.count != 0 ? 1 : 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VSIHeaderTableViewCell", for: indexPath) as? VSIHeaderTableViewCell else {return UITableViewCell()}
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            cell.bindData(data: patientScanslist[indexPath.row])
            return cell
        case 2, 4:
            return UITableViewCell()
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            let data = PatientScan(first_name: "", last_name: "", id: 1, time_stamp: "12", prop_C: 12.0, prop_T: 12.6, prop_L: 14.7, dl_C: 12.6, dl_T: 15.7, dl_L: 12.6, lean: 17.8, height: 18.0, pic_date: "12.0")
            cell.bindData(data: data)
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            let data = PatientScan(first_name: "", last_name: "", id: 1, time_stamp: "12", prop_C: 12.0, prop_T: 12.6, prop_L: 14.7, dl_C: 12.6, dl_T: 15.7, dl_L: 12.6, lean: 17.8, height: 18.0, pic_date: "12.0")
            cell.bindData(data: data)
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell else {return UITableViewCell()}
            let data = PatientScan(first_name: "", last_name: "", id: 1, time_stamp: "12", prop_C: 12.0, prop_T: 12.6, prop_L: 14.7, dl_C: 12.6, dl_T: 15.7, dl_L: 12.6, lean: 17.8, height: 18.0, pic_date: "12.0")
            cell.bindData(data: data)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 2, 4:
            return 20
        default:
            return UITableView.automaticDimension
        }
    }
}
