//
//  ViewController.swift
//  TinyUDP
//
//  Created by Daniel Bonates on 02/03/17.
//  Copyright © 2017 Daniel Bonates. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    let host = "239.255.255.250"
    let port = 1900
    var socket: UDPSocket?
    
    let timeout: Double = 10.0
    let timeInterval: Double = 1.0
    var timeoutTimer: Timer?
    var broadcastResponded = false
    var broadcastFiredTime: Date?
    
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var logField: NSTextView!
    @IBOutlet weak var fireBtn: NSButton!
    @IBOutlet weak var spin: NSProgressIndicator!
    
    let renderMedia = "urn:schemas-upnp-org:device:MediaRenderer:1"
    let connManager = "urn:schemas-upnp-org:service:ConnectionManager:1"
    let renderControll = "urn:schemas-upnp-org:service:RenderingControl:1"
    let smartInput = "urn:schemas-udap:service:smartText:1"
    let remoteControll = "urn:schemas-udap:service:netrcu:1"
    let allServices = "udap:rootservice"
    
    var stCommands = [
        "urn:schemas-upnp-org:device:MediaRenderer:1",
        "urn:schemas-upnp-org:service:ConnectionManager:1",
        "urn:schemas-upnp-org:service:RenderingControl:1",
        "urn:schemas-udap:service:smartText:1",
        "urn:schemas-udap:service:netrcu:1",
        "udap:rootservice"
    ]
    
    var packetString: String {
        return "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: \(allServices)\r\n\r\n"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        tableView?.reloadData()
    }
    
    @IBAction func fireAction(_ sender: Any) {
        guard tableView.selectedRow > -1 else { return }
        let researcher = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: \(stCommands[tableView.selectedRow])\r\n\r\n"
        fireCommand(researcher)
    }
    
    func startTimer() {
        
        broadcastFiredTime = Date()
        timeoutTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkBroadcastResponse), userInfo: nil, repeats: true)
    }
    
    func checkBroadcastResponse() {
        
        guard let interval = broadcastFiredTime?.timeIntervalSinceNow else { return }
        
        let situation = (broadcastResponded, abs(interval) > timeout)
        print(situation)
        switch situation {
        case (true, _):
            finalizeTimer(with: true)
        case (false, true):
            finalizeTimer(with: false)
        default: break
        }
    }
    
    func finalizeTimer(with success: Bool) {
        switch success {
        case true:
            
            timeoutTimer?.invalidate()
            broadcastResponded = true
        case false:
            timeoutTimer?.invalidate()
            broadcastResponded = false
            logField.string = "no TV found, maybe it's off or not on same wifi?!"
        }
        spin.stopAnimation(nil)
        fireBtn.isEnabled = true
    }
    
    deinit {
        socket?.close()
    }
    
    func fireCommand(_ researcher: String) {
        
        if self.socket == nil {
            self.socket = UDPSocket(address: host, port: port)
        }
        
        guard let socket = self.socket else { print("insuficient data to create a socket."); return }
        broadcastResponded = false
        fireBtn.isEnabled = false
        spin.startAnimation(nil)
        startTimer()
        
        DispatchQueue.global().async {
            socket.send(packet: researcher) { [weak self] result in
                
                DispatchQueue.main.async {
                
                    switch result {
                    case .failure(let error):
                        self?.logField.string = error.localizedDescription
                        self?.finalizeTimer(with: false)
                    case .success(let result):
                        guard let socketResponse = result as? SocketResponse else { return }
                        self?.logField.string = socketResponse.debugDescription
                        self?.finalizeTimer(with: true)
                    }
                    
                    self?.fireBtn.isEnabled = true
                }
            }
        }
        
    }
    
    // MARK: - TableView Delegate / Datasource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stCommands.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {

        let command = stCommands[row]
        
        guard let identifier = tableColumn?.identifier else { return ""}
        switch identifier {
        case "stCommand":
            return command
        default:
            return ""
        }
        
    }
}

