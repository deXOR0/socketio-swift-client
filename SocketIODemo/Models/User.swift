//
//  User.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 16/10/22.
//

import Foundation
import Auth0
import JWTDecode

struct User {
    var id: String
    var accessToken: String
    var name: String
    var nickname: String
    var picture: String
    var email: String
    
    init(credentials: Credentials) {
        if let jwt = try? decode(jwt: credentials.idToken) {
            self.name = jwt["name"].string!
            self.nickname = jwt["nickname"].string!
            self.picture = jwt["picture"].string!
            self.email = jwt["email"].string!
            
            self.id = credentials.idToken
            self.accessToken = credentials.accessToken
        }
        else {
            self.name = "NoAuth"
            self.nickname = "NoAuth"
            self.picture = "NoAuth"
            self.email = "NoAuth"
            self.id = "NoAuth"
            self.accessToken = "NoAuth"
        }
    }
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case accessToken
//        case name
//        case nickname
//        case picture
//        case email
//    }
}
