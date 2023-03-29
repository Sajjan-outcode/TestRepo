//
//  VSIReportHeaderView.swift
//  Upright
//
//  Created by Sajjan on 22/02/2023.
//

import UIKit
import SnapKit

class VSIReportHeaderView: View {
    
    private lazy var mainView: View = {
        let view = View()
        view.backgroundColor = .white
        return view
        
    }()
    
    private lazy var topView: View = {
        let view = View()
        return view
        
    }()
    
    private lazy var topLogoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "VsiReportImage"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
        
    }()
    
    private lazy var reportInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var patientInformationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Patient Information"
        return label
    }()
    
    private lazy var reportGenerationDatelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Report Generation Date"
        return label
    }()
    
    private lazy var reportGenerateDateView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Colors.blackColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var generateDatelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 18,weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var patienInfoView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Colors.blackColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    private lazy var patientName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var patientEmail: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private lazy var clinicInformationlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.text = "Clinic Information"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var clinicInformationView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Colors.blackColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var clinicNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clinicAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clinicAddressValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var clinicAddressStackView: UIStackView = {
        let subViews = [clinicAddressLabel,clinicAddressValueLabel]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clinicPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clinicPhoneValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var clinicPhoneStackView: UIStackView = {
        let subViews = [clinicPhoneLabel,clinicPhoneValueLabel]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clinicEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clinicEmailValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var clinicEmailStackView: UIStackView = {
        let subViews = [clinicEmailLabel,clinicEmailValueLabel]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fieldStackView: UIStackView = {
        let subViews = [clinicAddressStackView,clinicPhoneStackView,clinicEmailStackView]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = .vertical
        view.spacing = 2
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        self.addSubview(mainView)
        mainView.snp.makeConstraints{ make in
            make.top.left.right.bottom.equalToSuperview()
        }
        mainView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(75)
        }
        
        topView.addSubview(topLogoImageView)
        topLogoImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        mainView.addSubview(patientInformationLabel)
        patientInformationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(topView.snp.bottom).offset(8)
            make.width.equalTo(mainView.snp.width).multipliedBy(0.6)
        }
        
        mainView.addSubview(reportGenerationDatelabel)
        reportGenerationDatelabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(patientInformationLabel)
            make.left.equalTo(patientInformationLabel.snp.right).offset(16)
        }
        
        mainView.addSubview(patienInfoView)
        patienInfoView.snp.makeConstraints { make in
            make.top.equalTo(patientInformationLabel.snp.bottom).offset(2)
            make.left.right.equalTo(patientInformationLabel)
        }
        patienInfoView.addSubview(patientName)
        patientName.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview().inset(12)
        }
        
        patienInfoView.addSubview(patientEmail)
        patientEmail.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(12)
            make.top.equalTo(patientName.snp.bottom).offset(2 )
        }
        
        mainView.addSubview(reportGenerateDateView)
        reportGenerateDateView.snp.makeConstraints { make in
            make.top.equalTo(reportGenerationDatelabel.snp.bottom).offset(2)
            make.left.right.equalTo(reportGenerationDatelabel)
            make.height.equalTo(patienInfoView.snp.height)
        }
        
        reportGenerateDateView.addSubview(generateDatelabel)
        generateDatelabel.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview().inset(12)
        }
        
        mainView.addSubview(clinicInformationlabel)
        clinicInformationlabel.snp.makeConstraints { make in
            make.top.equalTo(patienInfoView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        mainView.addSubview(clinicInformationView)
        clinicInformationView.snp.makeConstraints { make in
            make.top.equalTo(clinicInformationlabel.snp.bottom).offset(4)
            make.left.right.equalTo(clinicInformationlabel)
            make.bottom.equalToSuperview()
        }
        
        clinicInformationView.addSubview(clinicNameLabel)
        clinicNameLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(16)
            make.width.equalTo(mainView.snp.width).multipliedBy(0.6)
        }
        
        clinicInformationView.addSubview(fieldStackView)
        fieldStackView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(16)
            make.left.equalTo(clinicNameLabel.snp.right).offset(8)
        }
        
    }
    
    
     func patientInfoData(viewModel: VSIReportInfoModel){
         print(viewModel.currentDate)
        patientName.text = viewModel.patientFirstName
        patientEmail.text = viewModel.patientEmail
        generateDatelabel.text = viewModel.setCurrentDate()
        clinicEmailValueLabel.text = viewModel.clinicEmail
        clinicNameLabel.text = viewModel.clinicName
        clinicAddressValueLabel.text = viewModel.clinicAddress
        clinicEmailValueLabel.text = viewModel.clinicEmail
        clinicPhoneValueLabel.text = viewModel.clinicPhone
        
    }
    
}
