//
//  AppDelegate.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 11/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Cocoa
import LocalAuthentication

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    @IBOutlet weak var touchBar: NSTouchBar!
    @IBOutlet weak var statusMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appDelegate.touchBar = touchBar
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EasyOTP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
    
    var localAuthenticationContext = LAContext()
    let items = [""]
    let secrets = [""]
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        
        let icon = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.button?.image = icon
        statusItem.menu = statusMenu
        
        loadMenu()
        
    }
    
    
    func deleteItem(issuer: String){
        getManagedContext()?.delete((getItems()?.first{$0.issuer == issuer })!)
        getManagedContext()?.saveIt()
        loadMenu()
        
    }
    
    
    func saveItem(issuer: String, username: String, secret: String){
        getManagedContext()?.run {
            //KEYS
            let entity = NSEntityDescription.entity(forEntityName: "Keys", in: $0)!
            let key = NSManagedObject(entity: entity, insertInto: $0)
            key.setValue(issuer, forKeyPath: "issuer")
            key.setValue(username, forKeyPath: "username")
            key.setValue(secret, forKeyPath: "secret")
            key.setValue(NSDate().timeIntervalSince1970, forKeyPath: "createddate")
            
            $0.saveIt()
            loadMenu()
        }
    }
    
    func getItems() -> [Keys]?{
        var result: [Keys] = []
        getManagedContext()?.run {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Keys")
            request.returnsObjectsAsFaults = false
            do {
                 result = try $0.fetch(request) as! [Keys]
            } catch {
                print("Failed")
            }
        }
        return result
    }
    
    @objc func addItemClicked(){
        print("addItemClicked")
        let myWindowController = NSStoryboard(name:
            NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(
                    rawValue: "addWindow")) as! NSWindowController
        myWindowController.window?.makeKeyAndOrderFront(self)
        myWindowController.showWindow(self)
        NSApplication.shared.activate(ignoringOtherApps: true)
        
    }
    
    @objc func removeItemClicked(){
        print("removeItemClicked")
        let myWindowController = NSStoryboard(name:
            NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(
                    rawValue: "removeWindow")) as! NSWindowController
        myWindowController.window?.makeKeyAndOrderFront(self)
        myWindowController.showWindow(self)
        NSApplication.shared.activate(ignoringOtherApps: true)
        
    }
    
    @objc func invalidateAuth(){
        localAuthenticationContext = LAContext()
        print("LAContext()")
    }
    
    
    func getItemName(key: Keys) -> String{
        return key.issuer! + " | " + key.username!
    }
    
    func loadMenu(){
        statusMenu.removeAllItems()
        getItems()?.forEach { item in
            let index = getItems()?.index(of: item)
            statusMenu.addItem(withTitle: getItemName(key: item), action: #selector(otpItemClicked), keyEquivalent: String(Int(index!)+1))
        }
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Add...", action: #selector(addItemClicked), keyEquivalent: "A")
        statusMenu.addItem(withTitle: "Remove...", action: #selector(removeItemClicked), keyEquivalent: "R")
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Quit", action: #selector(quitClicked), keyEquivalent: "Q")
    }
    
    func copyToClipboard(text: String){
        // Set string to clipboard
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(text, forType: NSPasteboard.PasteboardType.string)
        
        var clipboardItems: [String] = []
        for element in pasteboard.pasteboardItems! {
            if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                clipboardItems.append(str)
            }
        }
    }
    
    
    func getToken(secret: String) -> String {
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = 1
        var authError: NSError?
        let reasonString = "To access the secure data"
        var token = ""
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    //TODO: User authenticated successfully, take appropriate action
                    let data = base32DecodeToData(secret)
                    let totp = TOTP(secret: data!)!
                    print("Token gerado")
                    self.copyToClipboard(text: totp.generate(time: Date()))
                    self.postNotification(title: "EasyOTP", subtitle: "Token copied!", informativeText: "Just paste it ;)", image: "success")
                    print("Token copiado")
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return ""
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
        
        return token
        
    }
    
    
    
    
    
    @IBAction func otpItemClicked(sender: NSMenuItem) {
        
        print(getToken(secret: (getItems()?.first{self.getItemName(key: $0) == sender.title}?.secret)!))
        
        Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { [weak self] timer in
            self?.invalidateAuth()
        }
    }
    
    func postNotification(title: String, subtitle: String, informativeText: String, image: String? ){
        let notification = NSUserNotification()
        notification.identifier = String(Date().timeIntervalSince1970)
        notification.title = title
        notification.soundName = "Morse"
        notification.subtitle = subtitle
        notification.informativeText = informativeText
        if(image != nil){
            notification.contentImage = NSImage(named: NSImage.Name(rawValue: image!))
        }
        // Manually display the notification
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }

}

