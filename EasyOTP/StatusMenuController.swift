//
//  StatusMenuController.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 12/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Cocoa
import LocalAuthentication

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    var localAuthenticationContext = LAContext()
    let items = [""]
    let secrets = [""]
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {

        //        let icon = NSImage(named: "statusIcon")
        //        icon?.isTemplate = true // best for dark mode
        statusItem.title = "EasyOTP"
        statusItem.menu = statusMenu
        
//        items.forEach { item in
//            let index = items.index(of: item)
//            statusMenu.addItem(withTitle: item, action: #selector(otpItemClicked), keyEquivalent: String(Int(index!)+1))
//        }
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Add...", action: #selector(addItemClicked), keyEquivalent: "S")
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Quit", action: #selector(quitClicked), keyEquivalent: "Q")
    }
    
    @objc func addItemClicked(){
        print("addItemClicked")
        let myWindowController = NSStoryboard(name:
            NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(
                    rawValue: "primaryWindow")) as! NSWindowController
        myWindowController.showWindow(self)
        
    }
    
    @objc func invalidateAuth(){
        localAuthenticationContext = LAContext()
        print("LAContext()")
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
//        print(getToken(secret: "OABYGOOMDFQQY6TQ3AVOPWQGMDJNYUXDRFNZHPIWA64PECHLQNZ4V5TNT7PXVPLF"))
        Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { [weak self] timer in
            self?.invalidateAuth()
        }
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
