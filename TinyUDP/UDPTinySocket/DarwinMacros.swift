//
//  DarwinMacros.swift
//  TinyUDP
//
//  Created by Daniel Bonates on 02/03/17.
//  Copyright © 2017 Daniel Bonates. All rights reserved.
//
//
//  Swift interface for C functions
//  more info: https://realm.io/news/russ-bishop-unsafe-swift/
//
//

import Foundation

@_silgen_name("yudpsocket_recive") func c_yudpsocket_recive(_ fd:Int32,buff:UnsafePointer<UInt8>,len:Int32,ip:UnsafePointer<Int8>,port:UnsafePointer<Int32>) -> Int32
@_silgen_name("yudpsocket_close") @discardableResult func c_yudpsocket_close(_ fd:Int32) -> Int32
@_silgen_name("yudpsocket_client") func c_yudpsocket_client() -> Int32
@_silgen_name("yudpsocket_get_server_ip") func c_yudpsocket_get_server_ip(_ host:UnsafePointer<Int8>,ip:UnsafePointer<Int8>) -> Int32
@_silgen_name("yudpsocket_sentto") func c_yudpsocket_sentto(_ fd:Int32,buff:UnsafePointer<UInt8>,len:Int32,ip:UnsafePointer<Int8>,port:Int32) -> Int32
@_silgen_name("enable_broadcast") func c_enable_broadcast(_ fd:Int32)
