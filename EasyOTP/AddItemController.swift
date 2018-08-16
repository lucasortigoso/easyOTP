//
//  ViewController.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 13/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

class AddItemController: NSViewController {
    
    @IBOutlet weak var txtIssuer: NSTextField!
    @IBOutlet weak var txtUserName: NSTextField!
    @IBOutlet weak var txtSecret: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        print("Close")
        self.view.window!.performClose(nil) // or performClose(self)
        
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Save")
        appDelegate.saveItem(issuer: self.txtIssuer.stringValue, username: self.txtUserName.stringValue, secret: self.txtSecret.stringValue)
        self.view.window!.performClose(nil) // or performClose(self)
    }
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
