//
//  ViewController.swift
//  Alamat Task
//
//  Created by prog_zidane on 8/6/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
   @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    @IBAction func didRegisterPressed(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        self.view.showLoader(activityColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
        UserServices.shared.registerNewUser(email: email, password: password) { (success,error) in
           self.view.removeLoader()
            if success {
            
                SuccessMessage(title: "Success", body: "you have been registerd successfully")
                
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                self.present(homeVC ,animated: true,completion:nil)
            }else {
                ErrorMessage(title: "Error", body:error )
            }
        }
    }
    

    @IBAction func didLoginPressed(_ sender: Any) {
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(loginVC ,animated: true,completion:nil)
    
        
    }
}

