//
//  UIVewPdfExtention.swift
//  Upright
//
//  Created by Sajjan on 29/03/2023.
//
import UIKit
extension UIView {
    
    func exportAsPdfFromView() -> NSMutableData {
        
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        let pdfContext = UIGraphicsGetCurrentContext()
        self.layer.render(in: pdfContext!)
        UIGraphicsEndPDFContext()
        return  pdfData
        
    }

    public func generatePDF(title: String) -> URL {
            let pdfData = exportAsPdfFromView()
            let temporaryDir = FileManager.default.temporaryDirectory
            let tempFilePath = temporaryDir.appendingPathComponent("\(title) \(Date().toString(withFormat: "yyyy-MM-dd")).pdf")
            do {
                try? pdfData.write(to: tempFilePath, options: .atomic)
              }
           return tempFilePath
        }
    
    
}
