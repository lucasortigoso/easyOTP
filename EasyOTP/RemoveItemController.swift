
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

class RemoveItemController: NSViewController, NSComboBoxDataSource {
    
    
    @IBOutlet weak var rcbItems: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        appDelegate.getItems()?.forEach({ (item) in
            rcbItems.addItem(withTitle: item.issuer!)
        })
        
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        print("Close")
        self.view.window!.performClose(nil) // or performClose(self)
        
        
    }
    
    @IBAction func removeButtonClicked(_ sender: Any) {
        print("Remove")
        appDelegate.deleteItem(issuer: (rcbItems.selectedItem?.title)!)
        self.view.window!.performClose(nil) // or performClose(self)
    }
    


    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
