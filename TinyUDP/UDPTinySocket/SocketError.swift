//
//  SocketError.swift
//  TinyUDP
//
//  Created by Daniel Bonates on 02/03/17.
//  Copyright © 2017 Daniel Bonates. All rights reserved.
//

import Foundation


enum SocketError: Error {
    case queryFailed
    case connectionClosed
    case connectionTimeout
    case unknownError
}
