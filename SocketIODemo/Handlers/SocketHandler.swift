//
//  SocketHandler.swift
//  SocketIODemo
//
//  Created by Atyanta Awesa Pambharu on 10/10/22.
//

import Foundation
import SocketIO

class SocketHandler: NSObject {
    static let sharedInstance = SocketHandler()
    let socket = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!

    override init() {
        super.init()
        mSocket = socket.socket(forNamespace: "/invite")
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection(token: String) {
        mSocket.connect(withPayload: ["token": "Bearer \(token)"])
    }

    func closeConnection() {
        mSocket.disconnect()
    }
}
