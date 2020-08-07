//
//  LoginViewController.swift
//  Exchangeagram
//
//  Created by Ck2 Jedi on 8/6/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("login button tapped")
    }
    
}
