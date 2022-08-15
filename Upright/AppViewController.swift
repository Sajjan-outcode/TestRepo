//
//  AppViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/4/22.
//

import Foundation
import UIKit

class AppViewController: LoginViewController {
    
    func transitionView() {
       if let homeViewController =
        storyboard?.instantiateViewController(withIdentifier: HomeViewController.homeViewController){
        present(homeViewController, animated: true, completion: nil)
       }
    }
}
