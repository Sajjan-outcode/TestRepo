//
//  PreviewViewController.swift
//  Upright
//
//  Created by outcode  on 28/08/2023.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

class PreviewViewController: UIViewController {
    private lazy  var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Colors.blackColor
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
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
    
    var imageUrl: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        imageView.image = imageUrl
    }
    
    @objc func onNoBtnClick() {
        self.dismiss(animated: true)
    }
    
    
    private func setUpView() {
        self.view.addSubview(imageView)
        self.view.addSubview(closeButton)
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.equalTo(self.imageView.snp.right).inset(16.0)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(self.imageView.snp.top).inset(20)
        }
        
    }
    
}
