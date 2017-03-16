import Foundation


final class UDPSocket {
  
    var address: String = ""
    var port: Int32 = 0
    var fd: Int32 = 0
    
    var dataReceived: SocketResponse {
        
        let expectlen: Int = 1024*10
        guard self.fd > 0 else {
            return SocketResponse(data: "", ip:"", port:0)
        }
        var buff: [UInt8] = [UInt8](repeating: 0x0, count: expectlen)
        var remoteipbuff: [Int8] = [Int8](repeating: 0x0, count: 16)
        var remoteport: Int32 = 0
        let readLen: Int32 = c_yudpsocket_recive(fd, buff: buff, len: Int32(expectlen), ip: &remoteipbuff, port: &remoteport)
        let port: Int = Int(remoteport)
        let address = String(cString: remoteipbuff, encoding: String.Encoding.utf8) ?? ""
        
        if readLen <= 0 {
            return SocketResponse(data: "", ip:address, port: port)
        }
        
        let data: [UInt8] = Array(buff[0..<Int(readLen)])
        
        let dataInfo = String(bytes: data, encoding: .utf8)
        
        return SocketResponse(data: dataInfo ?? "", ip: address, port: port)
    }
    

    init?(address: String, port: Int) {
        
        self.port = Int32(port)
        self.fd = c_yudpsocket_client()
        
        let remoteipbuff: [Int8] = [Int8](repeating: 0x0,count: 16)
        let ret = c_yudpsocket_get_server_ip(address, ip: remoteipbuff)
        
        guard self.fd > 0, let ip = String(cString: remoteipbuff, encoding: String.Encoding.utf8), ret == 0, !ip.isEmpty, port > 0 else {
            return nil
        }
        self.address = ip
        c_enable_broadcast(fd)
    }
    
    func send(packet: String, completion: (Result<Any>) -> ()) {
        
        guard self.fd > 0 else { completion(.failure(SocketError.connectionClosed)); return }
        
        let sendsize = c_yudpsocket_sentto(fd, buff: packet, len: Int32(strlen(packet)), ip: address, port: port)
        if sendsize == Int32(strlen(packet)) {
            return completion(.success(dataReceived))
        } else {
            return completion(.failure(SocketError.unknownError))
        }
    }
    
    func close() {
        guard self.fd > 0 else { return }
        c_yudpsocket_close(fd)
    }
    
}
