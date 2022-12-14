//
//  ViewController.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 10/10/22.
//

import UIKit
import Auth0
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet weak var inviteCodeTextField: UITextField!
    @IBOutlet weak var codingTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var currentRoomLabel: UILabel!
    
    let notificationCenter = UNUserNotificationCenter.current()
    let userDefaults = UserDefaults.standard
    let credentialHandler = CredentialHandler.sharedInstance

    var user: User?
    var roomCode = ""
    var mSocket = SocketHandler.sharedInstance.getSocket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        hideKeyboardWhenTappedAround()
        
        let credentials = credentialHandler.storedCredentials
        print("STORED \(credentials)")
        self.user = User(credentials: credentials!)
        
        self.usernameLabel.text = self.user?.name
        self.profilePicture.load(url: URL(string: self.user!.picture)!)
        
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if (!permissionGranted) {
                print("Permission Denied!")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        // The follwing line connects the IOS app to the server.
        SocketHandler.sharedInstance.establishConnection(token: self.user!.accessToken)
        
        
        mSocket.on("room joined") { (dataArray, ack) -> Void in
            let inviteCode = dataArray[0] as! String
            self.roomCode = inviteCode
            self.currentRoomLabel.text = "Current Room: \(inviteCode)"
            self.inviteCodeTextField.text = inviteCode
        }
        
        mSocket.on("output") { (dataArray, ack) -> Void in
            let output = dataArray[0] as! String
            self.outputTextView.text = output
        }
        
        mSocket.on("alert") { (dataArray, ack) -> Void in
            print(dataArray)
            let title = dataArray[0] as! String
            let msg = dataArray[1] as! String
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = msg
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { (error) in
                if (error != nil) {
                    print("Error " + error.debugDescription)
                    return
                }
            }
        }
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    print("Logged out")
                    self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                case .failure(let error):
                    print("Failed with: \(error)")
            }
        }
        credentialHandler.logout()
    }
    
    @IBAction func joinRoomButtonPressed(_ sender: UIButton) {
        guard let inviteCode = inviteCodeTextField.text else {
            return
        }
        if inviteCode != "" {
            mSocket.emit("join", inviteCode)
        }
    }
    
    @IBAction func runCodeButtonPressed(_ sender: UIButton) {
        outputTextView.text = ""
        guard let coding = codingTextView.text else {
            return
        }
        let input = inputTextView.text ?? ""
        if coding != "" {
            mSocket.emit("run code", roomCode, coding, input)
        }
    }
    
    @IBAction func submitCodeButtonPressed(_ sender: UIButton) {
        outputTextView.text = ""
        guard let coding = codingTextView.text else {
            return
        }
        let input = inputTextView.text ?? ""
        if coding != "" {
            mSocket.emit("submit code", roomCode, coding, input)
        }
    }
    
    @IBAction func generateNewRoomButtonPressed(_ sender: UIButton) {
        mSocket.emit("create");
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }
    
}


