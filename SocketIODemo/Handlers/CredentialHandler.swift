//
//  CredentialManager.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 19/10/22.
//

import Foundation
import Auth0

class CredentialHandler: NSObject {
    static let sharedInstance = CredentialHandler()
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    var storedCredentials: Credentials?

    override init() {
        super.init()
    }

    func storeCredentials(credentials: Credentials) -> Bool {
        return credentialsManager.store(credentials: credentials)
    }

    func isStoredCredentials() -> Bool {
        return credentialsManager.hasValid()
    }

    func retrieveStoredCredentials(_ callback: @escaping (Error?) -> ()) {
        credentialsManager.credentials { result in
            switch result {
            case .success(let credentials):
                print("CREDENTIAL MANAGER: \(credentials)")
                self.storedCredentials = credentials
                callback(nil)
            case .failure(let error):
                print("Error")
                callback(error)
            }
        }
    }
    
    func logout() -> Bool {
        // Remove credentials from KeyChain
        self.storedCredentials = nil
        return self.credentialsManager.clear()
    }
}
