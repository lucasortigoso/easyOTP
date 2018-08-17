//
//  TodayViewController.swift
//  today
//
//  Created by Lucas Ortigoso on 16/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView?
    
    @IBOutlet weak var dddd: NSTextFieldCell?
    
    fileprivate enum CellIdentifiers {
        static let TokenView = "TokenViewCellID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        
        dddd?.stringValue = "Lucas"
    }
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var issuer: String = ""
        var username: String = ""
        var token: String = ""
        var cellIdentifier: String = ""
        
        
        if tableColumn == tableView.tableColumns[0] {
            issuer = "AWS - Account"
            username = "lucas.ortigoso"
            token = "938383"
            cellIdentifier = CellIdentifiers.TokenView
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSCustomTableViewCell {
            cell.txtIssuer?.stringValue = issuer
            cell.txtUsername?.stringValue = username
            cell.txtToken?.stringValue = token
            return cell
        }
        return nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
    
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }
    
}




class NSCustomTableViewCell: NSTableCellView {
    
    @IBOutlet weak var txtIssuer: NSTextField?
    @IBOutlet weak var txtUsername: NSTextField?
    @IBOutlet weak var txtToken: NSTextField?
}
