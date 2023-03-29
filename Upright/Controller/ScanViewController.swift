//
//  ScanViewController.swift
//  Upright
//
//  Created by Sajjan on 24/03/2023.
//

import UIKit
import SnapKit


class ScanViewController: BaseViewController {
    
    private lazy var containerView : View  = {
        let view = View()
        return view
    }()
    
    private lazy var imageView: View = {
        let view = View()
        view.backgroundColor = .white
        return view
        
    }()
    
    private lazy var vsiScanPortalView: View = {
        let view = View()
        return view
    }()
    
    private lazy var vsiScanPortalLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var connectButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var initiateButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var detectButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
