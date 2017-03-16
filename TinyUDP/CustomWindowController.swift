//
//  CustomWindowController.swift
//  TinyUDP
//
//  Created by Daniel Bonates on 16/03/17.
//  Copyright © 2017 Daniel Bonates. All rights reserved.
//

import Cocoa

class CustomWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titleVisibility = .visible
        window?.titlebarAppearsTransparent = true
        window?.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        window?.isMovableByWindowBackground = true
        window?.title = "tiny UDP"
    }
}
