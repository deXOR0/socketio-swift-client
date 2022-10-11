//
//  ViewController.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 10/10/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet weak var inviteCodeTextField: UITextField!
    @IBOutlet weak var codingTextView: UITextView!
    @IBOutlet weak var currentRoomLabel: UILabel!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var roomCode = ""
    var mSocket = SocketHandler.sharedInstance.getSocket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        hideKeyboardWhenTappedAround()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if (!permissionGranted) {
                print("Permission Denied!")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        // The follwing line connects the IOS app to the server.
        SocketHandler.sharedInstance.establishConnection()
        
        
        mSocket.on("room joined") { (dataArray, ack) -> Void in
            let inviteCode = dataArray[0] as! String
            self.roomCode = inviteCode
            self.currentRoomLabel.text = "Current Room: \(inviteCode)"
            self.inviteCodeTextField.text = inviteCode
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
    
    @IBAction func joinRoomButtonPressed(_ sender: UIButton) {
        guard let inviteCode = inviteCodeTextField.text else {
            return
        }
        if inviteCode != "" {
            mSocket.emit("join", inviteCode)
        }
    }
    
    @IBAction func runCodeButtonPressed(_ sender: UIButton) {
        guard let coding = codingTextView.text else {
            return
        }
        if coding != "" {
            mSocket.emit("run code", roomCode, coding)
        }
    }
    
    @IBAction func submitCodeButtonPressed(_ sender: UIButton) {
        guard let coding = codingTextView.text else {
            return
        }
        if coding != "" {
            mSocket.emit("submit code", roomCode, coding)
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

