//
//  User.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 16/10/22.
//

import Foundation

struct User: Codable {
    var id: String
    var accessToken: String
    var name: String
    var nickname: String
    var picture: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case accessToken
        case name
        case nickname
        case picture
        case email
    }
}
