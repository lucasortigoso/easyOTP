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
    @IBOutlet weak var txtError: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        print("Close")
        self.view.window!.performClose(nil) // or performClose(self)
        
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Save")
        if(self.txtIssuer.stringValue.lengthOfBytes(using: String.Encoding.utf8) > 0 &&
        self.txtUserName.stringValue.lengthOfBytes(using: String.Encoding.utf8) > 0 &&
            self.txtSecret.stringValue.lengthOfBytes(using: String.Encoding.utf8) > 0){
            appDelegate.saveItem(issuer: self.txtIssuer.stringValue, username: self.txtUserName.stringValue, secret: self.txtSecret.stringValue)
            self.view.window!.performClose(nil) // or performClose(self)
        } else {
            self.txtError.isHidden = false
        }
    }
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
