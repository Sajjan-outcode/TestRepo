//
//  VSIReportViewModel.swift
//  Upright
//
//  Created by Sajjan on 15/02/2023.
//

import UIKit

enum ScanImageDownloadState {
    case downloading
    case downloaded
    case failed
}
protocol VSIReportViewModelDelegate: AnyObject {
    func refreshScanImageList()
}

class VSIReportViewModel {
    
    weak var delegate: VSIReportViewModelDelegate?
        
    private var vsiReportInfoModel: VSIReportInfoModel
    private var patientId: Int
    
    var scanImages: [Int: (image: UIImage?, state: ScanImageDownloadState)] = [:]
    var patientScanslist: [PatientScan]
    var patientScanVSICellModel: [VSIReportCellModel] = []
    var surveyScore: [QuestionsScore] = []
    
    init(patientId: Int, vsiReportInfoModel: VSIReportInfoModel, patientScanList: [PatientScan], surveyList: [QuestionsScore]) {
        self.patientId = patientId
        self.vsiReportInfoModel = vsiReportInfoModel
        self.patientScanslist = patientScanList
        let  scanController: ScanController = ScanController()
        
        let surveyListLength = surveyList.count
        for (index,item) in patientScanList.enumerated() {
            self.surveyScore.append(surveyList[index])
            patientScanVSICellModel.append(VSIReportCellModel.getModel(patientId: patientId,
                                                                       patientScan: item, surveyData: index < surveyListLength ? surveyList[index] : surveyList.first  , scanController: scanController))
        }
    }
    private func downloadScanImage(forItemAt index: Int) {
        let scan = patientScanslist[index]
        guard let host = db.host,
              let scanId = scan.id,
              let picDate = scan.pic_date,
            let url = URL(string: "http://\(host):8000/media/\(scanId)-\(picDate).png")else {
            return
        }
        scanImages[scanId] = (nil, .downloading)
        getData(from: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            guard let data = data, error == nil else {
                strongSelf.scanImages[scanId] = (nil, .failed)
                strongSelf.delegate?.refreshScanImageList()
                return
            }
            guard let image = UIImage(data: data) else {
                strongSelf.scanImages[scanId] = (nil, .failed)
                strongSelf.delegate?.refreshScanImageList()
                return
            }
            strongSelf.scanImages[scanId] = (image, .downloaded)
            strongSelf.delegate?.refreshScanImageList()
        }
    
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    completion(data, response, error)
                }
            }
            task.resume()
        }
        
    }
    
    func getDeltaModel() -> VSIReporDeltaCellModel {
        guard let vsiReportDeltaCellModel = VSIReporDeltaCellModel.getModel(patientId: Patient.id!, patientScanCell: patientScanVSICellModel, questionSurvey: self.surveyScore) else {
            return VSIReporDeltaCellModel(date: "", statureValue: "", leanValue: "", sXfXValue: "", proportionCervicalValue: "", proportionThoracicValue: "", proportionLumbarValue: "", normalityCervicalValue: "", normalityThoracicValue: "", normalityLumbarValue: "", vsiScoreValue: "")
            
        }
        return vsiReportDeltaCellModel //VSIReporDeltaCellModel.getModel(patientId: Patient.id!, patientScanCell: patientScanVSICellModel)
    }
    
    func getDeviationModel() -> VSIReportDeviationCellModel {
        guard let vsiReportDeviationCellModel = VSIReportDeviationCellModel.getModel(patientId: Patient.id!, patientScanCell: patientScanVSICellModel, questionSurvey: self.surveyScore) else {
            return VSIReportDeviationCellModel(date: "", statureValue: "", leanValue: "", sXfXValue: "", proportionCervicalValue: "", proportionThoracicValue: "", proportionLumbarValue: "", normalityCervicalValue: "", normalityThoracicValue: "", normalityLumbarValue: "", vsiScoreValue: "")
            
        }
        
        return vsiReportDeviationCellModel
    }
    
}

extension VSIReportViewModel {
    
    func getReportInfo() -> VSIReportInfoModel {
        return vsiReportInfoModel
    }
    
    func getImageForScan(at index: Int) -> UIImage? {
        if let scanImage = scanImages[patientScanslist[index].id] {
            switch scanImage.state {
            case .downloaded:
                return scanImage.image
            case .downloading:
                return nil
            case .failed:
                return nil
            }
        }
        downloadScanImage(forItemAt: index)
        return nil
    }
    
}
