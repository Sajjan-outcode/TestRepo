import UIKit
import SnapKit

class VSIReportController: UIViewController {
    
    var viewModel: VSIReportViewModel!
  
    private lazy var tableHeaderView: VSIReportHeaderView = {
            let view =  VSIReportHeaderView()
            view.snp.makeConstraints { make in
                make.width.equalTo(self.view.bounds.width)
            }
          view.patientInfoData(viewModel: viewModel.getReportInfo())
          return view
    }()
    
    private lazy var tableFooterView: VSIReportFooterCell = {
            let view =  VSIReportFooterCell()
            view.viewModel = viewModel
            view.snp.makeConstraints { make in
                make.width.equalTo(self.view.bounds.width)
            }
        return view
    }()
    
    private lazy var tableSectionHeaderView: UIView = {
        let viewTe = Bundle.main.loadNibNamed("VSIReportSectionHeaderView", owner: nil, options: nil)
        let view = viewTe?.first as! UIView
        return view
    }()
    
    
    private lazy var shareBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named:"share"), for: .normal)
        view.setTitleColor(Colors.white, for: .normal)
        view.addCornerRadius(10)
        view.addTarget(self, action: #selector(onShareBtnClick), for: .touchUpInside)
        return view
    }()
    
    
    private lazy var closeBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(named: "cross")
        let tintImage = btnImage?.withRenderingMode(.alwaysTemplate)
        view.setImage(tintImage, for: .normal)
        view.tintColor =  Colors.appRedColor
        view.addTarget(self, action: #selector(onNoBtnClick), for: .touchUpInside)
        return view
    }()
    
    
    // MARK: Outlets
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(VSIReportSubHeaderCell.self)
        view.register(VSIReportTargetDataCell.self)
        view.dataSource = self
        view.delegate = self
        view.clipsToBounds = true
        view.separatorStyle = .none
        if #available(iOS 15, *) {
           view.sectionHeaderTopPadding = 0
        }
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: ViewController Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.tableHeaderView = tableHeaderView
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIView.layoutFittingCompressedSize.height))
        footerView.addSubview(tableFooterView)
        tableFooterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.tableFooterView = footerView
        tableView.layoutIfNeeded()
        attachCloseAndShareBtn()
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      guard let footerView = self.tableView.tableFooterView else {
        return
      }
      let width = self.tableView.bounds.size.width
      let size = footerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
      if footerView.frame.size.height != size.height {
        footerView.frame.size.height = size.height
        self.tableView.tableFooterView = footerView
      }
    }
    
    @objc func onShareBtnClick() {
        self.shareBtn.isHidden = true
        self.closeBtn.isHidden = true
         let pdfFilePath = self.view.generatePDF(title: Patient.first_name ?? "")
         let shareAll = [pdfFilePath]
           let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        if let popOver = activityViewController.popoverPresentationController {
            popOver.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popOver.sourceView = self.view
            popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
         }
        self.present(activityViewController, animated: true)
        self.closeBtn.isHidden = false
        self.shareBtn.isHidden = false
 }
    
    @objc func onNoBtnClick() {
        self.dismiss(animated: true)
    }
    
    private func attachCloseAndShareBtn(){
        self.view.addSubview(closeBtn)
        self.view.addSubview(shareBtn)
        closeBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).inset(16.0)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(self.view.snp.top).inset(30)
        }
        
        shareBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).inset(40)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.snp.bottom).inset(40)
        }
    }

}

extension VSIReportController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.patientScanVSICellModel.count
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return tableSectionHeaderView
        case 1:
            let view = UIView()
            return view
        case 2:
            let view = UIView()
            return view
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 10
        case 2:
            return 10
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VSIReportSubHeaderCell", for: indexPath) as? VSIReportSubHeaderCell else {
                return UITableViewCell()
            }
            cell.dataModel = viewModel.patientScanVSICellModel[indexPath.row]
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VSIReportSubHeaderCell", for: indexPath) as? VSIReportSubHeaderCell else {
                return UITableViewCell()
            }
            cell.deltaModel = viewModel.getDeltaModel()
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VSIReportTargetDataCell", for: indexPath) as? VSIReportTargetDataCell else {
                return UITableViewCell()
            }
            return cell
           
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VSIReportSubHeaderCell", for: indexPath) as? VSIReportSubHeaderCell else {
                return UITableViewCell()
            }
            cell.deviationModel = viewModel.getDeviationModel()
            return cell
          
        }
    }
}
