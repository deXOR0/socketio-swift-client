//
//  LoginViewController.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 16/10/22.
//

import UIKit
import Auth0
import JWTDecode

class LoginViewController: UIViewController {
    
    let userDefaults: UserDefaults = UserDefaults.standard
    let credentialManager: CredentialHandler = CredentialHandler.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        Auth0
            .webAuth()
            .audience("http://localhost:3000/invite")
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                    print("Store credential: \(self.credentialManager.storeCredentials(credentials: credentials))")
                    self.credentialManager.retrieveStoredCredentials { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print(String(describing: error))
                                return
                            }
                            self.performSegue(withIdentifier: "gotoMain", sender: nil)
                        }
                    }
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    print("Logged out")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
        credentialManager.logout()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
