//
//  ProfileViewController.swift
//  Alamat Task
//
//  Created by prog_zidane on 8/6/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var user : UserProfile?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = ""
        passwordLabel.text = ""
        locationLabel.text = ""
        tokenLabel.text = ""
        guard let uid = Auth.auth().currentUser?.uid else {return}
         self.view.showLoader(activityColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
        UserServices.shared.observeUserProfile(uid) { (returnedUser) in
            self.view.removeLoader()
            if returnedUser != nil {
                self.user = returnedUser
                DispatchQueue.main.async {
                    self.emailLabel.text = returnedUser?.userName!
                    self.passwordLabel.text = returnedUser?.password!
                    self.locationLabel.text = returnedUser?.location!
                    self.tokenLabel.text = returnedUser?.token!
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func didClosePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didLogOutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "token")

        UserDefaults.standard.removeObject(forKey: "email")
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        self.present( registerVC,animated: true,completion:nil)
        
        
    }
    
}
