//
//  SocketResponse.swift
//  TinyUDP
//
//  Created by Daniel Bonates on 02/03/17.
//  Copyright © 2017 Daniel Bonates. All rights reserved.
//

import Foundation

struct SocketResponse {
    let data: String
    let ip: String
    let port: Int
}

extension SocketResponse: CustomDebugStringConvertible {
    var debugDescription: String {
        var str = "SocketResponse:\n- ip: \(ip)"
        str += "\n- port: \(port)"
        str += "\n- data:\n"
        str += data
        return str
    }
}
