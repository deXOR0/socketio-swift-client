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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                    guard let jwt = try? decode(jwt: credentials.idToken),
                          let name = jwt["name"].string,
                          let nickname = jwt["nickname"].string,
                          let picture = jwt["picture"].string,
                          let email = jwt["email"].string
                    else { return }
                    let id = credentials.idToken
                    let accessToken = credentials.accessToken
                    let user = User(id: id, accessToken: accessToken, name: name, nickname: nickname, picture: picture, email: email)
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(user)
                        self.userDefaults.set(data, forKey: "User")
                    }
                    catch {
                        
                    }
                    self.performSegue(withIdentifier: "gotoMain", sender: nil)
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
