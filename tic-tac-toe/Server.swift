//
//  Server.swift
//  tic-tac-toe
//
//  Created by Ruslan Cheshko on 7/30/15.
//  Copyright (c) 2015 Ukrainian.Solutions. All rights reserved.
//

import Foundation

struct Server {
    
    static var acceptSocket: CInt = -1
    static var acceptClient: CInt = -1
    static var playground = [0x00, 0x00, 0x00,
                             0x00, 0x00, 0x00,
                             0x00, 0x00, 0x00]
    
    static func start() {
        var error: NSError?
        if let socket = Socket.tcpForListen(port: 8081, error: &error) {
            println(socket)
            Server.acceptSocket = socket
            
        } else {
            println("Error while creating socket")
            println(error)
        }

    }
    
    static func waitForClient() {
        if let client = Socket.acceptClientSocket(Server.acceptSocket) {
            println("client")
            Server.acceptClient = client
            Socket.writeData(client, data: NSData(bytes: [0xFF, 0x02] + Server.playground, length: 11))
        }
    }
    
    static func nextInt8(socket: CInt) -> [UInt8] {
        var buffer = [UInt8](count: 11, repeatedValue: 0);
        let next = recv(socket as Int32, &buffer, Int(buffer.count), 0)
        if next <= 0 { return buffer }
        return buffer
    }
    
    static func waitDataFromClient() -> [UInt8] {
        if Server.acceptClient > 0 {
            let buffer = nextInt8(Server.acceptClient)
            return buffer
        }
        return []
    }
    
    static func stop() {
        Socket.release(Server.acceptClient)
        Socket.release(Server.acceptSocket)
    }
    
    static func waitClient() {

    }
    
    
    
}

