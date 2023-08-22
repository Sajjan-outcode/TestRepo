//
//  PatientAttachmentViewController.swift
//  Upright
//
//  Created by outcode  on 15/08/2023.
//

import UIKit
import SnapKit

class PatientAttachmentViewController: UIViewController {
    
    private lazy var wrapperView: UIView  = {
       let view = UIView()
        view.backgroundColor = Colors.white
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(named: "cross")
        let tintImage = btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintImage, for: .normal)
        button.tintColor =  Colors.appRedColor
        button.addTarget(self, action: #selector(onNoBtnClick), for:.touchUpInside)
        return button
        
    }()
    
    private lazy var patientInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.blueColor
        view.addCornerRadius(10)
        return view
        
    }()
        
    private lazy var patientNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Patient Name :"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientName: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.text = "Jhon"
       return label
        
    }()
    
    private lazy var patientEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Patient Email :"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientEmail: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.text = "Jhon"
       return label
        
    }()
    
    private lazy var patientAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Patient Address :"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientAddress: UILabel = {
        let label = UILabel()
        label.text = "Outcode"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone  :"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientPhone: UILabel = {
        let label = UILabel()
        label.text = "Outcode"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var fileAttachmentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose File", for: .normal)
        button.addCornerRadius(2)
        button.setTitleColor(Colors.blackColor, for: .normal)
        button.backgroundColor = Colors.white
        button.addTarget(self, action: #selector(openAtttachmentOption), for:.touchUpInside)
        return button
        
    }()
    
    var collectionView : UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachmentView()
        attchmentTopView()
        collectionViewSetup()
    }
    
    
    
    @objc func onNoBtnClick() {
        self.dismiss(animated: true)
    }
    
    private func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        collectionView.layer.borderColor = Colors.grayColor.cgColor
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        collectionView.backgroundColor = UIColor.white
        self.wrapperView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.patientInfoView.snp.bottom).offset(10)
            make.right.equalTo(self.patientInfoView.snp.right)
            make.left.equalTo(self.patientInfoView.snp.left)
            make.bottom.equalToSuperview()
        }
 
    }
    
    private func attachmentView() {
        
        self.view.addSubview(wrapperView)
        self.wrapperView.addSubview(closeButton)
        self.wrapperView.addSubview(patientInfoView)
        
        wrapperView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.equalTo(self.wrapperView.snp.right).inset(16.0)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(self.wrapperView.snp.top).inset(30)
        }
        
       
    }
    
    private func attchmentTopView() {
        self.wrapperView.addSubview(patientInfoView)
        self.patientInfoView.addSubview(patientNameLabel)
        self.patientInfoView.addSubview(patientName)
        self.patientInfoView.addSubview(patientEmailLabel)
        self.patientInfoView.addSubview(patientEmail)
        self.patientInfoView.addSubview(patientAddressLabel)
        self.patientInfoView.addSubview(patientAddress)
        self.patientInfoView.addSubview(patientPhoneLabel)
        self.patientInfoView.addSubview(patientPhone)
        self.patientInfoView.addSubview(fileAttachmentButton)
                
        patientInfoView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.right.equalTo(self.wrapperView.snp.right).inset(10)
            make.left.equalTo(self.wrapperView.snp.left).inset(10)
            make.height.equalTo(200)
        }
        
        patientNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.patientInfoView.snp.top).inset(25)
            make.left.equalTo(self.patientInfoView.snp.left).inset(16)
        }
        
        patientName.snp.makeConstraints { make in
            make.top.equalTo(self.patientInfoView.snp.top).inset(25)
            make.left.equalTo(self.patientNameLabel.snp.right).offset(16)
        }
        
        patientEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.patientNameLabel.snp.bottom).offset(8)
            make.left.equalTo(self.patientInfoView.snp.left).inset(16)
        }
        patientEmail.snp.makeConstraints { make in
            make.top.equalTo(self.patientName.snp.bottom).offset(8)
            make.left.equalTo(self.patientEmailLabel.snp.right).offset(16)
        }
        
        patientAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(self.patientEmailLabel.snp.bottom).offset(8)
            make.left.equalTo(self.patientInfoView.snp.left).inset(16)
        }
        
        patientAddress.snp.makeConstraints { make in
            make.top.equalTo(self.patientEmail.snp.bottom).offset(8)
            make.left.equalTo(self.patientAddressLabel.snp.right).offset(16)
        }
        
        patientPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(self.patientAddressLabel.snp.bottom).offset(8)
            make.left.equalTo(self.patientInfoView.snp.left).offset(16)
        }
        
        patientPhone.snp.makeConstraints { make in
            make.top.equalTo(self.patientAddressLabel.snp.bottom).offset(8)
            make.left.equalTo(self.patientPhoneLabel.snp.right).offset(16)
        }
        
        fileAttachmentButton.snp.makeConstraints { make in
            make.top.equalTo(self.patientInfoView.snp.top).inset(30)
            make.right.equalTo(self.patientInfoView.snp.right).inset(16)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        
    }
    
    @objc private func openAtttachmentOption() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           alertController.addAction(UIAlertAction(title: "Take Photo", style: .default) {  _ in
              //  self.openCamera()
            })

            alertController.addAction(UIAlertAction(title: "Photo library", style: .default) {  _ in
             ///   self.openGallery()
            })

            alertController.addAction(UIAlertAction(title: "Document", style: .default) { _ in
               // self.openDocument()
            })

             alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = self.view
                alertController.popoverPresentationController?.sourceRect = self.view.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]

            }

            self.present(alertController, animated: true)
    }
    
}

extension PatientAttachmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in your collection view
        return 10 // Change this value according to your data
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath)
        
        // Customize the cell's appearance and content
        
        return cell
    }
    
    
    
}
