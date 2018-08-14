//
//  StringExtension.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 12/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Foundation
import CoreData
import Cocoa

extension String {
    /// Data never nil
    internal var dataUsingUTF8StringEncoding: Data {
        return utf8CString.withUnsafeBufferPointer {
            return Data(bytes: $0.dropLast().map { UInt8.init($0) })
        }
    }
    
    /// Array<UInt8>
    internal var arrayUsingUTF8StringEncoding: [UInt8] {
        return utf8CString.withUnsafeBufferPointer {
            return $0.dropLast().map { UInt8.init($0) }
        }
    }
}

protocol HasApply { }
extension HasApply {
    func apply(closure:(Self) -> ()) -> Self {
        closure(self)
        return self
    }
}
extension NSObject: HasApply { }

protocol HasRun { }
extension HasRun {
    func run(closure:(Self) -> ()) {
        closure(self)
    }
}
extension NSObject: HasRun { }

//extension NSViewController {
//    var appDelegate:AppDelegate {
//        return NSApplication.shared.delegate as! AppDelegate
//    }
//
//    func getManagedContext() -> NSManagedObjectContext? {
//        //GET MANAGED CONTEXT
//        return appDelegate.persistentContainer.viewContext
//
//    }
//}

extension NSObject {
    var appDelegate:AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        //GET MANAGED CONTEXT
        return appDelegate.persistentContainer.viewContext
        
    }
}


protocol SaveIt { }
extension HasRun {
    func saveIt(closure:(Self) -> ()) {
        closure(self)
    }
}
extension NSManagedObjectContext: SaveIt { }



extension NSManagedObjectContext {
    
    func saveIt(){
        do {
            try self.save()
            print("Saved!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}







