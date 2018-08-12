//
//  StatusMenuController.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 12/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let items = ["AWS For1","AWS Helpie DEV"]
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    override func awakeFromNib() {
        //        let icon = NSImage(named: "statusIcon")
        //        icon?.isTemplate = true // best for dark mode
        statusItem.title = "EasyOTP"
        statusItem.menu = statusMenu
        
        items.forEach { item in
            statusMenu.addItem(withTitle: item, action: #selector(otpItemClicked), keyEquivalent: item)
        }
        
        statusMenu.addItem(withTitle: "Sair", action: #selector(quitClicked), keyEquivalent: "Q")
    }
    
    
    @IBAction func otpItemClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
