//
//  PatientAttachmentViewController.swift
//  Upright
//
//  Created by outcode  on 15/08/2023.
//

import UIKit
import SnapKit

class PatientAttachmentViewController: UIViewController {
    
    var imagePicker: UIImagePickerController!
    
    private lazy var wrapperView: UIView  = {
       let view = UIView()
        view.backgroundColor = Colors.white
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        return UIView.getHorizontalStackView(withPadding: 8.0, distribution: .fillEqually)
    }()
    
    private lazy var verticalStackView: UIStackView = {
        return UIView.getVerticalStackView(withPadding: 8.0)
    }()
    
    
    private lazy var patientInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.blueColor.withAlphaComponent(0.9)
        view.addCornerRadius(10)
        view.setRadiusWithShadow(10.0, color: Colors.appColor)
        return view
        
    }()
        
    private lazy var patientInfoTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = Colors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Patient Information"
        
    return label
    }()
    
    private lazy var patientNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientName: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.text = "Jhon"
       return label
        
    }()
    
  
    private lazy var patientNameHorizontalStackView: UIStackView = {
        let designView : [UILabel] = [patientNameLabel,patientName]
        let view = UIStackView(arrangedSubviews: designView)
        view.axis = .horizontal
        view.spacing = 4.0
        view.distribution = .equalSpacing
        return view
        
    }()
    
    private lazy var patientEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientEmail: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.text = "Jhon"
       return label
        
    }()
    
    private lazy var patientEmailHorizontalStackView: UIStackView = {
        let designView : [UILabel] = [patientEmailLabel,patientEmail]
        let view = UIStackView(arrangedSubviews: designView)
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
        
    }()
    
    private lazy var patientAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientAddress: UILabel = {
        let label = UILabel()
        label.text = "Outcode"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientAddressHorizontalStackView: UIStackView = {
        let designView : [UILabel] = [patientAddressLabel,patientAddress]
        let view = UIStackView(arrangedSubviews: designView)
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
        
    }()
    
    private lazy var patientPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientPhone: UILabel = {
        let label = UILabel()
        label.text = "Outcode"
        label.textColor = Colors.white
        return label
        
    }()
    
    private lazy var patientPhoneHorizontalStackView: UIStackView = {
        let designView : [UILabel] = [patientPhoneLabel,patientPhone]
        let view = UIStackView(arrangedSubviews: designView)
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .equalSpacing
    
        return view
        
    }()
    
    private lazy var topImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "navLogo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
        
    }()
    
    private lazy var topLogoBannerView: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.appWhiteColor.withAlphaComponent(1)
        return view
        
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(named: "cross")
        let tintImage = btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintImage, for: .normal)
        button.tintColor =  Colors.darkGrayColor
        button.addTarget(self, action: #selector(onNoBtnClick), for:.touchUpInside)
        return button
        
    }()
    
    private lazy var fileAttachmentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose File", for: .normal)
        button.addCornerRadius(10)
        button.setTitleColor(Colors.darkGrayColor, for: .normal)
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PatientAttachmentCollectionViewCell.self, forCellWithReuseIdentifier: "PatientAttachmentCollectionViewCell")
        collectionView.backgroundColor = UIColor.white
        self.wrapperView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.patientInfoView.snp.bottom).offset(10)
            make.right.equalTo(self.patientInfoView.snp.right).inset(10)
            make.left.equalTo(self.patientInfoView.snp.left).inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func attachmentView() {

        self.view.addSubview(wrapperView)
        self.wrapperView.addSubview(patientInfoView)
        
        wrapperView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func attchmentTopView() {
        self.wrapperView.addSubview(patientInfoView)
        self.patientInfoView.addSubview(fileAttachmentButton)
        self.wrapperView.addSubview(verticalStackView)
        self.wrapperView.addSubview(patientInfoTextLabel)
        self.wrapperView.addSubview(topLogoBannerView)
        self.topLogoBannerView.addSubview(topImageView)
        self.topLogoBannerView.addSubview(closeButton)
        
        topLogoBannerView.snp.makeConstraints { make in
            make.top.equalTo(self.wrapperView.snp.top).inset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.patientInfoView.snp.top).offset(-20)
            make.height.equalTo(80)
            
        }
        
        topImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.topLogoBannerView)
            make.height.equalTo(70)
            make.width.equalTo(140)
        }
        
        
        closeButton.snp.makeConstraints { make in
            make.right.equalTo(self.topLogoBannerView.snp.right).inset(16.0)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(self.topLogoBannerView)
        }
        
        patientInfoView.snp.makeConstraints { make in
            make.right.equalTo(self.wrapperView.snp.right).inset(10)
            make.left.equalTo(self.wrapperView.snp.left).inset(10)
            make.height.equalTo(200)
        }
        
        patientInfoTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.patientInfoView.snp.top).inset(12)
            make.left.equalTo(self.patientInfoView.snp.left).inset(20)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.left.equalTo(self.patientInfoView.snp.left).inset(20)
            make.centerY.equalTo(self.patientInfoView)
            }
        
        verticalStackView.addArrangedSubview(patientNameHorizontalStackView)
        verticalStackView.addArrangedSubview(patientEmailHorizontalStackView)
        verticalStackView.addArrangedSubview(patientAddressHorizontalStackView)
        verticalStackView.addArrangedSubview(patientPhoneHorizontalStackView)
        
        fileAttachmentButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.patientInfoView)
            make.right.equalTo(self.patientInfoView.snp.right).inset(20)
            make.height.equalTo(60)
            make.width.equalTo(200)
        }
    }
    
 
    @objc private func openAtttachmentOption() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
           alertController.addAction(UIAlertAction(title: "Take Photo", style: .default) {  _ in
                self.openCamera()
            })

            alertController.addAction(UIAlertAction(title: "Photo library", style: .default) {  _ in
               self.openGallery()
            })

            alertController.addAction(UIAlertAction(title: "Document", style: .default) { _ in
               // self.openDocument()
            })

             alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if UIDevice.current.userInterfaceIdiom == .pad {
                
                if let popOver = alertController.popoverPresentationController {
                    popOver.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popOver.sourceView = self.view
                    popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                 }

            }
        
        self.present(alertController, animated: true)
    }
    
}

extension PatientAttachmentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in your collection view
        return 40 // Change this value according to your data
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PatientAttachmentCollectionViewCell", for: indexPath) as! PatientAttachmentCollectionViewCell
        cell.imageView.image = UIImage(named: "SxFx_Background")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4.25
        let widthOfCell = width
        return CGSize(width: widthOfCell, height: widthOfCell)
     }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 12.0
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension PatientAttachmentViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    
    func openCamera() {
   
            let mediaTypes = ["public.image", "public.movie"]
        
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.videoMaximumDuration = TimeInterval(300)
            self.imagePicker.mediaTypes = mediaTypes
            present(self.imagePicker, animated: true, completion: nil)
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }

}
