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

class AddItemController: NSViewController, NSApplicationDelegate {
    
    @IBOutlet weak var txtIssuer: NSTextField!
    @IBOutlet weak var txtUserName: NSTextField!
    @IBOutlet weak var txtSecret: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        print("Close")
        //        self.view.window!.performClose(nil) // or performClose(self)
        
        getManagedContext()?.run {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Keys")
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try $0.fetch(request) as! [Keys]
                print(result)
                
            } catch {
                print("Failed")
            }
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Save")
        getManagedContext()?.run {
            //KEYS
            let entity = NSEntityDescription.entity(forEntityName: "Keys", in: $0)!
            let key = NSManagedObject(entity: entity, insertInto: $0)
            key.setValue(self.txtIssuer.stringValue, forKeyPath: "issuer")
            key.setValue(self.txtSecret.stringValue, forKeyPath: "secret")
            key.setValue(self.txtUserName.stringValue, forKeyPath: "username")
            key.setValue(NSDate().timeIntervalSince1970, forKeyPath: "date")
            
            $0.saveIt()
        }
    }
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
